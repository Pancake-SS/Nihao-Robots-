# Cozy UI patch integration

The source is the user-supplied `nihao_ui_patch_modular_art_v4.zip` (15 November 2026). Its README, art notes, manifest and validation report were reviewed before merging. The patch was treated as design source, not as instructions to replace the working app or its data.

The app now uses the patch's warm theme, brand mark, compact sidebar, illustrated welcome and Home screens, Vocabulary cards, lesson and review styling, and modular decorative artwork. Original source robot PNGs remain unchanged: all 20 `assets/robots/robot_XX_dark/light.png` files match the 20 files in `Robot images/` by SHA-256. The ink variants are additional transparent artwork for light surfaces. Robot choices vary by screen and suit their backgrounds.

The existing SQLite curriculum, audio/TTS, per-profile queue, keyboard and lesson routes remain connected. The patch's older quiz file was not copied over the answer-checking implementation. Quiz visuals were integrated around the current logic. The separate `lib/preview_main.dart` is a sample-data-only UI workshop; `lib/main.dart` remains the real application.

The patch needed responsive fixes for 360-pixel screens at 200% text: welcome panel text, Home metrics, section headings, tutorial popup, and the queue's decorative header. The shared theme declares the display font for button labels, and the screenshot renderer loads that font so captures represent the actual interface. The patch's VS Code Chrome launch configuration was omitted because this full project has no `web/` scaffold. The current Windows build helper remains the reliable route for the workspace path containing `!`.

Run the actual app using `scripts/build_windows.ps1`, then open the executable path printed on success. In VS Code, **Terminal > Run Build Task** invokes that helper. The optional workshop source uses sample data and does not store learner progress or exercise grading.

On 15 November 2026, the user supplied `Cream Robot Reading with Books.png` for the dark welcome panel. The panel now places that exact image in the bottom-right corner against black. Desktop and mobile widget renders were inspected so the robot clears the heading. The original robot drawings were not changed.
