# Naseej AI-Assisted Development Log

SMAC 2026 permits AI to be used as a supporting tool but prohibits using AI
to generate the complete application.

Every meaningful AI interaction used in the project is recorded here.

| Date | Developer | Tool | Exact Prompt File | Purpose | Contribution Used | Human Review and Changes | Related Commit |
|---|---|---|---|---|---|---|---|
| 2026-08-06 | axbh25 | ChatGPT | `prompts/2026-08-06-day-01-clean-setup.md` | Plan a clean Windows, Flutter, Android, GitHub, Figma, and emulator setup | Installation sequence, repository structure, emulator choice, documentation templates | Developer executed each step manually, checked current official documentation, and did not accept a generated application | `8dd4e73` created the log; `be5fbae` expanded the documented rules |
| 2026-08-07 | axbh25 | ChatGPT | `prompts/2026-08-07-day-02-plan.md` | Perform a read-only repository audit and plan the bilingual Welcome screen | Repository findings, Figma specifications, localization structure, isolated Flutter code templates, and test templates | Developer reviewed each file, adapted values to approved Figma frames, ran formatting, analysis, tests, emulator checks, and visual overlays; AI did not generate the complete application | `Add Naseej design tokens and bilingual welcome screen` and `Test RTL welcome flow and document Day 2 results` |
| 2026-08-08 | Abdullah Haider and Shoug Almaashari | ChatGPT | `prompts/2026-08-08-day-03-plan.md` | Audit the current repository and plan one persistent local-profile feature | Repository findings, Figma dimensions, storage architecture, isolated Flutter file templates, localization strings, and test templates | Team reviewed the existing source, implemented the files individually, verified both languages, ran automated tests, tested real Android restart restoration, and corrected visual differences against Figma; AI did not generate the complete application | `9b8a39e`, `3dda8c5`, `152e692`, `0abc9c0`, and `9afadec` |
| 2026-08-10 | Abdullah Haider and Shoug Almaashari | ChatGPT | `prompts/2026-08-10-day-04-plan.md` | Audit the Day 3 repository and plan one typed skill-draft feature | Repository findings, Figma dimensions, isolated model, storage, form, Home, localization, and test templates | The team reviewed every file, adapted the implementation to approved Figma frames, ran unit and widget tests, verified airplane-mode saving and Android restart restoration, and corrected visual differences; AI did not generate the complete application | `986301a`, `adfeb93`, `df9786c`, `803d628`, `3d705b9`,
`7b2959a`, `c4271d`, and `b6cd24e` |
| 2026-08-11 | Abdullah Haider and Shoug Almaashari | ChatGPT | `prompts/2026-08-11-day-05-plan.md` | Audit the Day 4 repository and plan one short speech-transcription feature | Repository findings, Figma states, Android setup, isolated speech-engine, controller, UI, localization, fallback, and test templates | The team reviewed each file, configured microphone permissions manually, tested English and Arabic recognition, verified typed fallback and editable text, and compared device screenshots with Figma; AI did not generate the complete application | `9e53096`, `e984281`, `79fe5ed`, and `46d571d` |

| 2026-08-12 | Abdullah Haider and Shoug Almaashari | ChatGPT | `prompts/2026-08-12-day-06-plan.md` | Audit the Day 5 repository and plan one private context-photo feature | Repository findings, Figma states, private-file architecture, model, form, Home, localization, cleanup, recovery, and test templates | The team reviewed each file, configured the emulator camera, tested camera and gallery behavior, verified private persistence and restart recovery, and compared device evidence with Figma; AI did not generate the complete application | Replace with final Day 6 commit hashes |
## Rules

1. Store the exact prompt, not only a summary.
2. Never place passwords, tokens, keys, or personal family data in a prompt.
3. Never request the complete Naseej application.
4. Request help for one small component, file, or error at a time.
5. Read and explain every proposed code line before using it.
6. Modify generated code to match the approved architecture and Figma design.
7. Run formatting, analysis, tests, and an emulator check.
8. Record what was accepted, changed, or rejected.
9. Do not call a local template a live AI result.
10. Do not use AI to fabricate GitHub history or a second contributor.


