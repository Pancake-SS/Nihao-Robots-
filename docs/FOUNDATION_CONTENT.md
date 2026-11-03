# Foundation introduction — content revision 1

Reviewed 2026-11-04. Implementation: `lib/features/onboarding/foundation_content.dart`.

This is a short orientation, not a scored lesson pack or a pronunciation assessment. Five product-purpose pages precede four pages about Hanzi, Pinyin, tone marks and a greeting/parting exchange. Text is original, brief instructional copy; no third-party recordings, images, exercises or long passages were imported. No claim of independent native-teacher approval is made.

## Fact-check references

- Hanzi and the Chinese script: [Open University, Chinese characters](https://www.open.edu/openlearn/languages/beginners-chinese-taster-course/content-section-3.4).
- Pinyin represents Chinese sounds with the Roman alphabet: [Open University, Pinyin](https://www.open.edu/openlearn/languages/beginners-chinese-taster-course/content-section-3.2).
- Four main tone marks, neutral tone and the written `mā / má / mǎ / mà` sequence: [Open University, Tones](https://www.open.edu/openlearn/languages/beginners-chinese-taster-course/content-section-3.3).
- `你好 / nǐ hǎo / Hello` and `再见 / zàijiàn / Goodbye`: [Open University, Greetings](https://www.open.edu/openlearn/languages/beginners-chinese-taster-course/content-section-4). The app joins `zàijiàn` as one word and capitalizes utterance-initial Pinyin; the reference displays syllables separately.
- Connected-speech change for two third tones, illustrated by `你好`: [Open University, tone changes](https://www.open.edu/openlearn/mod/oucontent/view.php?id=108532&section=_unit2.4). The displayed spelling retains underlying tones; the tone page explains the rising pronunciation of the first syllable.

References were consulted for facts, not imported as a licensed curriculum. The language examples are short conventional expressions. No audio license is assumed from public availability. Native-speaker review and lawful recordings remain release gates for pronunciation exercises and the future content pack.

## Behavior and scope

- The Home card offers this introduction on first use; it does not force a modal before the learner can switch profiles. Save and leave is the skip-for-now path. Next, Back and leaving explicitly save the current position; app-bar Back preserves the last successfully saved position.
- The nine positions are stable for content revision 1. Reordering or inserting pages later requires a versioned mapping/migration, not silently reinterpreting saved indices.
- Completion means the learner reached and acknowledged the final page. It awards no word, streak, fluency, quiz or mastery credit. Replays preserve completion.
- Pinyin respects the profile preference on the character and exchange pages. The Pinyin/tones teaching pages keep their examples visible and explain that exception.
- Every language page explicitly states audio is unavailable. There is no fake play control, listening test, microphone request or network dependency.
- Slides 2–6 inform the five opening pages, with modest copy about understanding and planned review. Their full illustrated navy scene and extra robot lineup are intentionally simplified to one activity card. Home/Vocabulary tours spotlight currently implemented controls; future streak/weekly-detail tour steps will be added alongside real metrics.
