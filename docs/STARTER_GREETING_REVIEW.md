# Starter greeting pilot — content review record

Current checkpoint 2026-11-06: pack `starter.greetings`, revision 3; unchanged sense `starter.greeting.nihao.1`; content schema 3. Asset: `assets/content/starter_greeting_v2.json`. Revision 1 remains a historical test fixture, not a bundled lesson.

Revision 3 preserves the five original examples and adds six recognition directions, translated cloze and typed Hanzi recall through the shared object-oriented generator. Distractors come from HearMandarin-derived starter words; the adaptation is CC BY-SA 4.0 with attribution. No recording was imported for this greeting. Historical attempts retain their original snapshots. The review below describes the unchanged expressions; its two-question section is revision-1 history. Full source/import details: [content database](CONTENT_DATABASE.md).

**Status: source-checked-pilot.** Codex performed an editorial/source check of the language facts, examples, Pinyin and answer keys. This is not independent native-teacher approval. The lesson displays that limitation. Independent teacher review is required before public release; do not silently change the status to `approved`.

## Sense and teaching conventions

你好 / nǐ hǎo means hello when greeting one person. Written Pinyin retains underlying lexical tones; the first syllable is pronounced with a rising tone in this third-tone combination. The lesson explains this distinction. Capitalization follows sentence/name position; syllables belonging to a word stay together. The personal name Xiaoming is an example, not a learner identity.

The five short examples and English teaching notes were assembled for this project from conventional expressions. No source dialogue, recording, photograph or dictionary database was imported. References below support language facts; they do not grant rights to redistribute their media. Audio is explicitly absent.

| Example | Pinyin | Meaning and context |
|---|---|---|
| 你好！ | Nǐ hǎo! | Hello; a greeting. |
| 你好，我叫小明。 | Nǐ hǎo, wǒ jiào Xiǎomíng. | Hello, my name is Xiaoming; 我叫 introduces a name. |
| 你好，很高兴认识你。 | Nǐ hǎo, hěn gāoxìng rènshi nǐ. | Hello, nice to meet you; the supporting phrase expresses pleasure at meeting someone. |
| 你好，请进。 | Nǐ hǎo, qǐng jìn. | Hello, please come in; welcoming someone into a room. |
| 你好，请坐。 | Nǐ hǎo, qǐng zuò. | Hello, please sit down; offering someone a seat. |

Supporting words receive brief glosses. The quiz tests only the greeting, not independent recall of the longer examples.

## References actually consulted

- [Open University: Greetings](https://www.open.edu/openlearn/languages/beginners-chinese-taster-course/content-section-4): greeting meaning, underlying Pinyin and the goodbye/thank-you contrast used in feedback.
- [Open University: Beginners' Chinese, tone changes](https://www.open.edu/openlearn/mod/oucontent/view.php?id=108532&section=_unit2.4): contextual third-tone change; written and spoken tone conventions are distinguished.
- [Michigan State University: CHS101 Chapter 1](https://openbooks.lib.msu.edu/chs101/chapter/chapter-1/): self-introduction structure, the meeting expression and component vocabulary. This source inconsistently marks the second syllable of 认识 between its phrase and vocabulary rows; it was not copied uncritically.
- [Yabla Chinese dictionary: 认识](https://chinese.yabla.com/chinese-english-pinyin-dictionary.php?define=%E8%AE%A4%E8%AF%86): confirms neutral-tone shi; this pilot uses `rènshi`. Reference lookup only, no dictionary import.
- [trainchinese: 请进，请坐](https://www.trainchinese.com/v2/wordDetails.php?rAp=0&tcLanguage=en&wordId=105345): invitation expressions, Pinyin and meanings for the final two examples.

## Questions and feedback

1. Hanzi → meaning: the greeting 你好 maps to **Hello**. Goodbye, Thank you and Please are distinct alternatives. Feedback explains 再见, 谢谢 and 请.
2. Meaning → Hanzi: the expression greeting someone with hello is **你好**. 谢谢, 请 and 再见 are distinct alternatives. This is not the Pinyin → Hanzi exercise on storyboard slide 22.

Each question has four unique options and exactly one correct option. Both must be correct to pass this small recognition check. Feedback appears after the attempt and schedule commit together. Passing does not demonstrate productive ability, pronunciation or mastery. Repeated fixed choices are suitable only for this small implementation pilot, not a complete assessment bank.

## Implementation evidence and release limits

The bundled asset is exercised by parser, SQLite and widget journey tests. Schema 2 validates exactly five examples, two distinct question kinds (`meaning` and `hanzi`), unique IDs/options, valid answer references and bounded text. Structural validation does not establish linguistic quality.

Initial success schedules a five-minute follow-up; any failure schedules five-minute relearning; a successful due review schedules one day. These injectable intervals are a limited early-review policy, not FSRS or an evidence-based graduation rule. No mastery or streak is awarded. Incorrect attempts remain in history.

Before public release: obtain independent teacher review of context, naturalness, Pinyin and distractors; record any corrections with a new content revision; verify lawful pronunciation assets before enabling audio; broaden retrieval evidence before adding mastery. Existing sense identity and learner history must survive content revisions.
