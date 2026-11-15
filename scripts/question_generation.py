"""Deterministic question strategies over imported records; no AI/network calls."""
from abc import ABC, abstractmethod
from dataclasses import dataclass
import hashlib
from functools import lru_cache
import re
import unicodedata


def normalized(text):
    return ''.join(unicodedata.normalize('NFC', text).casefold().split())


def meanings(text):
    # Conservative lexical overlap filter, not a claim of semantic equivalence.
    return {re.sub(r'^to\s+', '', part.strip().casefold())
            for part in re.split(r'[;/]', text) if part.strip()}


@lru_cache(maxsize=None)
def semantic_category(meaning):
    """A conservative English gloss group for plausible wrong answers."""
    senses = [re.sub(r'^(?:to|a|an|the)\s+', '', part.strip().casefold())
              for part in re.split(r'[;/]', meaning)]
    countries = {'united states', 'america', 'usa', 'china', 'japan', 'korea',
                 'south korea', 'north korea', 'france', 'germany', 'russia',
                 'india', 'canada', 'australia', 'brazil', 'england',
                 'united kingdom', 'britain', 'italy', 'spain', 'singapore',
                 'malaysia', 'thailand', 'vietnam'}
    if any(sense in countries for sense in senses): return 'country'
    groups = (
        ('family', r'\b(father|mother|dad|mom|parent|brother|sister|son|daughter|grandfather|grandmother|grandpa|grandma|uncle|aunt|husband|wife|cousin)\b'),
        ('color', r'\b(red|blue|green|yellow|orange|purple|pink|black|white|brown|gray|grey|color|colour)\b'),
        ('fruit', r'\b(apple|banana|orange|pear|peach|grape|strawberry|watermelon|mango|pineapple|fruit)\b'),
        ('animal', r'\b(dog|cat|bird|fish|horse|cow|pig|sheep|rabbit|tiger|lion|bear|panda|animal)\b'),
        ('transport', r'\b(car|bus|train|subway|metro|airplane|plane|taxi|bicycle|bike|ship|boat|transport)\b'),
        ('time', r'\b(today|tomorrow|yesterday|morning|afternoon|evening|night|week|month|year|hour|minute|day)\b'),
        ('place', r'\b(country|nation|city|town|village|province|continent|island|river|mountain|sea|ocean)\b'),
        ('school', r'\b(teacher|student|school|classroom|classmate|lesson|homework|exam|university|college)\b'),
        ('food', r'\b(rice|noodle|bread|egg|meat|chicken|beef|pork|vegetable|soup|dumpling|food|meal)\b'),
        ('drink', r'\b(water|tea|coffee|milk|juice|beer|wine|drink|beverage)\b'),
        ('body', r'\b(head|face|eye|ear|nose|mouth|hand|arm|leg|foot|heart|body)\b'),
        ('weather', r'\b(rain|snow|wind|sun|cloud|weather|storm|temperature)\b'),
    )
    for name, pattern in groups:
        if any(re.search(pattern, sense) for sense in senses): return name
    return ''


@dataclass(frozen=True)
class Example:
    hanzi: str
    meaning: str
    source_id: str


@dataclass(frozen=True)
class Word:
    id: str
    hanzi: str
    pinyin: str
    meaning: str
    band: int
    part_of_speech: str
    examples: tuple[Example, ...] = ()

    @classmethod
    def from_lesson(cls, record):
        details = record.get('details', {})
        return cls(record['id'], record['hanzi'], record['pinyin'], record['meaning'],
                   details.get('band', 1), details.get('partOfSpeech', ''),
                   tuple(Example(e['hanzi'], e['meaning'], e.get('sourceId', '')) for e in record['examples']))


@dataclass(frozen=True)
class Choice:
    id: str
    text: str


@dataclass(frozen=True)
class Question:
    id: str
    kind: str
    prompt: str
    options: tuple[Choice, ...]
    correct_option_id: str
    explanation: str

    def to_record(self):
        return dict(id=self.id, kind=self.kind, prompt=self.prompt,
                    options=[dict(id=o.id, text=o.text) for o in self.options],
                    correctOptionId=self.correct_option_id, explanation=self.explanation)


class InsufficientDistractors(ValueError):
    pass


class DistractorSelector:
    """Prefer related glosses at the same level, then safe POS fallbacks."""
    def __init__(self, words):
        self.by_band = {}
        seen = set()
        for word in words:
            if word.id in seen:
                raise ValueError('Duplicate word identity in question pool')
            seen.add(word.id)
            self.by_band.setdefault(word.band, []).append(word)

    def choose(self, target, kind, count=3):
        target_meanings = meanings(target.meaning)
        candidates = [word for band, words in self.by_band.items() if band <= max(1, target.band)
                      for word in words if word.id != target.id
                      and normalized(word.hanzi) != normalized(target.hanzi)
                      and normalized(word.pinyin) != normalized(target.pinyin)
                      and not (meanings(word.meaning) & target_meanings)]
        candidates.sort(key=lambda word: (
            semantic_category(word.meaning) != semantic_category(target.meaning)
            if semantic_category(target.meaning) else False,
            word.part_of_speech != target.part_of_speech,
            hashlib.sha256(f'{target.id}|{kind}|{word.id}'.encode()).hexdigest()))
        chosen = []
        for word in candidates:
            if any(normalized(getattr(word, field)) == normalized(getattr(other, field))
                   for other in chosen for field in ('hanzi', 'pinyin', 'meaning')):
                continue
            if any(meanings(word.meaning) & meanings(other.meaning) for other in chosen):
                continue
            chosen.append(word)
            if len(chosen) == count:
                return tuple(chosen)
        raise InsufficientDistractors(f'{target.id}/{kind}: fewer than {count} distinct safe distractors')


class QuestionPattern(ABC):
    kind: str

    @abstractmethod
    def generate(self, word, selector):
        """Return a question or None when this pattern lacks the required data."""

    def make(self, word, prompt, options):
        ordered = sorted(options, key=lambda o: hashlib.sha256(f'{word.id}|{self.kind}|{o.id}'.encode()).hexdigest())
        return Question(f'{word.id}.{self.kind}', self.kind, prompt, tuple(ordered), 'correct',
                        f'{word.hanzi} · {word.pinyin} · {word.meaning}. '
                        'Pinyin shows dictionary tones; connected speech can change tones.')


class ChoicePattern(QuestionPattern):
    def __init__(self, kind, answer_field, prompt):
        self.kind, self.answer_field, self.prompt = kind, answer_field, prompt

    def generate(self, word, selector):
        distractors = selector.choose(word, self.kind)
        options = [Choice('correct', getattr(word, self.answer_field))]
        options.extend(Choice(f'choice-{i}', getattr(other, self.answer_field)) for i, other in enumerate(distractors))
        return self.make(word, self.prompt.format(hanzi=word.hanzi, pinyin=word.pinyin, meaning=word.meaning), options)


class SentenceClozePattern(QuestionPattern):
    kind = 'cloze'

    def generate(self, word, selector):
        example = next((e for e in word.examples if e.hanzi.count(word.hanzi) == 1), None)
        if example is None:
            return None  # Never invent a sentence to fill a gap in a source.
        prompt = ('Complete the sentence to match the translation: '
                  f'{example.hanzi.replace(word.hanzi, "____", 1)} English: {example.meaning}')
        choices = [Choice('correct', word.hanzi)]
        choices.extend(Choice(f'choice-{i}', other.hanzi) for i, other in enumerate(selector.choose(word, self.kind)))
        return self.make(word, prompt, choices)


class TypedHanziPattern(QuestionPattern):
    kind = 'typed_hanzi'

    def generate(self, word, selector):
        return self.make(word, f'Type the Simplified Chinese word from this lesson for “{word.meaning}”.',
                         [Choice('correct', word.hanzi)])


def default_patterns():
    return (
        ChoicePattern('meaning', 'meaning', 'What does {hanzi} mean in this lesson?'),
        ChoicePattern('hanzi', 'hanzi', 'Which word means “{meaning}”?'),
        ChoicePattern('pinyin', 'pinyin', 'Choose the dictionary Pinyin for {hanzi} (“{meaning}”).'),
        ChoicePattern('pinyin_hanzi', 'hanzi', 'Which Hanzi matches {pinyin}? Meaning: {meaning}.'),
        ChoicePattern('meaning_pinyin', 'pinyin', 'Which Pinyin matches “{meaning}”?'),
        ChoicePattern('pinyin_meaning', 'meaning', 'What does {pinyin} mean? Choose the meaning of the word from this lesson.'),
        SentenceClozePattern(), TypedHanziPattern(),
    )


class QuestionBankGenerator:
    def __init__(self, words, patterns=None):
        self.selector = DistractorSelector(words)
        self.patterns = tuple(patterns if patterns is not None else default_patterns())
        if len({p.kind for p in self.patterns}) != len(self.patterns):
            raise ValueError('Duplicate question strategy kind')

    def generate(self, word):
        return [q.to_record() for pattern in self.patterns
                if (q := pattern.generate(word, self.selector)) is not None]

    def generate_many(self, words):
        bank, skipped = {}, {}
        for word in words:
            try:
                bank[word.id] = self.generate(word)
            except InsufficientDistractors as error:
                skipped[word.id] = str(error)
        return bank, skipped
