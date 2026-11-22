# Classical stories in Learning

**Learning → Classical stories** contains three offline works in simplified Classical Chinese, with an English translation for every reading. Classical Chinese differs substantially from modern spoken Mandarin. The reader has a Chinese/English switch, searchable chapter lists, adjustable text size, selectable text, Previous/Next controls, and a source link for each version.

An additional **Di Zi Gui · 弟子规** card opens [Tsoidug's simplified page](https://www.tsoidug.org/dizigui_trans_simp.php) in the browser. It pairs the original verses with modern Chinese and English translations by Feng Xinming. This is an online companion, separate from the 139 bundled offline readings, and also appears in Explore online.

| Work | Readings | Wikisource index revision | Source |
|---|---:|---:|---|
| 百句譬喻经, Buddhist parables | 98 | 2601002 | [Wikisource index](https://zh.wikisource.org/zh-hans/%E7%99%BE%E5%8F%A5%E8%AD%AC%E5%96%BB%E7%B6%93) |
| 庄子, Daoist stories and ideas | 33 | 11117695 | [Wikisource index](https://zh.wikisource.org/zh-hans/%E8%8E%8A%E5%AD%90) |
| 列子, Daoist stories and ideas | 8 | 2176036 | [Wikisource index](https://zh.wikisource.org/zh-hans/%E5%88%97%E5%AD%90) |

The index pages identify the original works as public domain. The Baiyu index credits 伽斯那 and Chinese translator 求那毗地; the Zhuangzi index describes later contributors beyond the inner chapters; the Liezi index attributes the work to 列禦寇. Wikisource also labels its site contributions [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/). The app retains each chapter's source URL and revision, presents collection credit in the reader, and bundles the license text at `assets/content/LICENSE-CC-BY-SA-4.0.txt`.

The asset `assets/content/classics_v1.json` contains 139 readings, 1,524 paragraphs and 138,518 Chinese characters, imported on 2026-11-19. Its SHA-256 is `3a2e5eb80919b4d419ac6bf699cdf3538665cdfb14319179d33c23115687ca45`. The importer preserves index order, strips Wikisource navigation templates, chooses the main reading when the source offers an `另` variant, converts Traditional to Simplified with the already-pinned OpenCC importer dependency, and rejects leftover markup or empty bodies. Learners can open the pinned source revision to inspect variants and context. The raw fetch cache is local under `.content-cache/` and is not bundled.

`assets/content/classics_english_v1.json` has an attributed English companion for all 139 IDs. The 98 parables use Shi Huijing's [Waken translation](https://waken.org/translations/han/piyu/baiyujing/) under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/): credit is displayed in the reader, the translation pack is shared on those terms for noncommercial use, and the source link opens the specific fascicle. The importer selected the parable bodies, removed surrounding navigation and fascicle text, and converted them to JSON paragraphs; these are formatting and selection changes to the source. Zhuangzi uses James Legge's 1891 translation, and Liezi uses Lionel Giles's 1912 translation for books 1–6 and 8 plus Anton Forke's 1912 translation for book 7. Those historical translations are public domain. The English edition is a companion at chapter level; its paragraphs are not line-aligned to the Chinese edition. See each chapter's English source link in the reader.

To refresh from Wikisource, install `scripts/requirements-content.txt` and run:

```powershell
.venv\Scripts\python.exe scripts\import_wikisource_classics.py
.venv\Scripts\python.exe scripts\import_classics_english.py
```

This reads the latest source revisions and changes the pack when the source changes. Review the new text, revision IDs and hash before committing. To rebuild from an existing local raw fetch without network access, use `--from-cache`.
