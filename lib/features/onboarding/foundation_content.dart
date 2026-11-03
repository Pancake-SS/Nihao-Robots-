// Original orientation copy, revision 1. Fact-check sources and release limits:
// docs/FOUNDATION_CONTENT.md. Keep order stable for persisted v1 positions.
class FoundationPage {
  const FoundationPage(
    this.title,
    this.body, {
    this.hanzi,
    this.pinyin,
    this.translation,
    this.teachesPinyin = false,
  });
  final String title;
  final String body;
  final String? hanzi;
  final String? pinyin;
  final String? translation;
  final bool teachesPinyin;
}

const foundationPages = [
  FoundationPage(
    'Hello from the robots',
    'Welcome to your Mandarin learning space. We will take a few small steps together. You can leave now and resume from Home.',
  ),
  FoundationPage(
    'A place to begin',
    'This introduction uses Simplified Chinese and English explanations. Start with the basics, even if you only have a few minutes today.',
  ),
  FoundationPage(
    'Understanding comes first',
    'Look for connections between a word, its sound and its meaning. Reading a page is a beginning; using a word independently takes practice.',
  ),
  FoundationPage(
    'Return, recall, reflect',
    'The planned lessons will combine examples, recall and spaced review. Those lessons are still being prepared. This introduction does not test or score you.',
  ),
  FoundationPage(
    'Meet the building blocks',
    'Next: characters, Pinyin, tones and a first exchange. Use Next to continue, Back to revisit a page, or Save and leave to return later.',
  ),
  FoundationPage(
    'Hanzi: Chinese characters',
    'Chinese writing uses characters, called Hanzi. A word can contain one character or several. Here, two characters form a greeting.',
    hanzi: '你好',
    pinyin: 'nǐ hǎo',
    translation: 'Hello',
  ),
  FoundationPage(
    'Pinyin: a guide to sounds',
    'Pinyin writes Mandarin sounds using Latin letters and tone marks. Its spelling has its own rules; read it as a pronunciation guide, not as English. Pinyin stays visible on pages that teach it.',
    hanzi: '你好',
    pinyin: 'nǐ hǎo',
    translation: 'Hello',
    teachesPinyin: true,
  ),
  FoundationPage(
    'Tones carry meaning',
    'Mandarin has four main tones and a neutral tone. The marks show a level, rising, dipping or falling tone. A neutral syllable has no tone mark. Tones can change in connected speech: in 你好, the first third tone is pronounced as a rising tone. Written examples cannot replace listening.',
    pinyin: 'mā · má · mǎ · mà',
    teachesPinyin: true,
  ),
  FoundationPage(
    'Your first exchange',
    'Greet someone with 你好 and part with 再见. Notice the characters, pronunciation guide and meaning together. Finishing this introduction records only that you have read it; it does not mark these words as learned.',
    hanzi: '你好！\n再见！',
    pinyin: 'Nǐ hǎo!\nZàijiàn!',
    translation: 'Hello!\nGoodbye!',
  ),
];
