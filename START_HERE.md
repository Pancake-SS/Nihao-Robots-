# How to use this VS Code / Codex starter kit

1. Extract the zip into **the root of your Mandarin app project** (or copy its contents into a new folder).
2. Add your **original robot images** under `assets/mascots/` or another identifiable assets directory. Preserve the original files unchanged.
3. Open the folder in VS Code and start Codex / your coding assistant in agent mode with workspace file access.
4. In that chat, paste the entire contents of `NI_HAO_ROBOT_VSCODE_MASTER_PROMPT.md` as the first message. If your assistant supports file references, explicitly attach/reference all three source documents and the PPTX.
5. Let it begin with **requirements/notes audit + project memory + first tested MVP slice**, not dozens of screens at once.
6. On future sessions, ask it to read `docs/PROJECT_MEMORY.md` and relevant sources before coding. It should update Markdown and regenerate Word after each meaningful task.

The kit includes:
- Full master prompt: `NI_HAO_ROBOT_VSCODE_MASTER_PROMPT.md`.
- Original source plan, coding standards and PowerPoint under `reference/` (in the full-source ZIP).
- Canonical persistent memory: `docs/PROJECT_MEMORY.md`.
- Readable Word journal: `docs/Development_Journal.docx`.
- Optional journal sync utility: `scripts/sync_journal.py` (`pip install python-docx`, then `python scripts/sync_journal.py`).

**If sources are in `reference/`,** Codex must search there; the prompt's listed filenames are basenames, not requirements to move files to the root. The example credentials shown in the PPT are design-only; never reuse them as actual login credentials.
