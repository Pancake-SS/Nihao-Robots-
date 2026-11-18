# Learning: immersion, writing and notebook

The sidebar's **Learning** destination contains three separate pages:

- **Explore online** is a searchable, filterable collection of 19 external reading, video, podcast, music and everyday-Chinese links. Each entry shows an approximate learner level and the free access available. The app opens the original site in the default browser when the learner taps **Open site**. It does not copy or download third-party media. Internet access is needed only after opening a link. Some sites ask for an account, offer both free and paid content, or vary by region.
- **Free writing** presents a randomly selected topic from an original local bank of 32 prompts. **Another topic** picks a different one before the entry is saved. Learners can write in Chinese, Pinyin or English and save the topic with their writing. This is personal practice, separate from Master tests and their writing gallery; it is not graded.
- **Notebook** stores titled personal notes with Chinese, Pinyin and English fields. Notes can be searched, edited and deleted. Writing and notebook lists show 20 entries per page. Unsaved edits prompt before leaving, and Save stays visible below long entries.

Both editors use the existing inline Chinese keyboard with English, Hanzi, Pinyin and All modes. The All mode inserts a Hanzi candidate and editable dictionary Pinyin/meaning drafts into the other fields. These drafts are not automatic sentence translations. Pasted Chinese survives scrolling because each editor owns its text controllers.

Schema 9 adds `learning_entries` with a profile foreign key, entry kind, title, optional writing prompt, three text fields and created/updated timestamps. All reads, edits and deletes are scoped to the active profile. The resource catalogue itself is a small, reviewed code-owned list; there is no runtime feed or account sync.

## Resource review

The pasted resource plan was used as a discovery reference, then a smaller list was checked on 2026-11-18 against accessible source sites and official channels. Examples include [Mandarin Bean](https://mandarinbean.com/), [HSK Reading](https://hskreading.com/), [Little Fox Chinese](https://chinese.littlefox.com/en), [MaoMi Chinese](https://maomichinese.com/podcast/), [Xiaogua Chinese](https://www.xiaoguachinese.com/video-library), [StreetVoice](https://streetvoice.com/) and their linked official YouTube channels. Zhihu restricted the automated access check, so its card warns that sign-in may be needed. The complete, editable list and access labels are in `lib/features/learning/resource_catalogue.dart`. It contains links and original short descriptions only; no source images, articles, streams or transcripts are bundled. Availability and free tiers can change, so review the links and labels periodically.
