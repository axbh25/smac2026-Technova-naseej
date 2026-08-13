# Day 8 Structured Skill Card Verification

**Date:** 2026-08-14  
**Branch:** `feature/day-08-structured-skill-card`  
**Reference device:** Pixel 7 Pro, Android API 36  
**Reference viewport:** 412 × 892

## Automated Checks

| Check | Result | Notes |
|---|---|---|
| `flutter pub get` | Pass | |
| `flutter gen-l10n` | Pass | |
| Dart formatting | Pass | |
| `flutter analyze` | Pass | |
| `flutter test` | Pass | |
| SkillCard JSON round trip | Pass | |
| Exactly-three-step validation | Pass | |
| AI model-name validation | Pass | |
| Draft-fingerprint validation | Pass | |
| AI generation controller success | Pass | |
| Automatic Offline Guide | Pass | |
| Manual Offline Guide avoids cloud | Pass | |

## Real AI Checks

| Check | Result | Notes |
|---|---|---|
| Explicit generation action | Pass | |
| English AI card | Pass | |
| Arabic AI card | Pass | |
| Exactly three steps | Pass | |
| Safety note present | Pass | |
| Teach-back question present | Pass | |
| Reciprocal suggestion present | Pass | |
| Origin label correct | Pass | |
| Model label correct | Pass | |
| Preview is not auto-saved | Pass | |
| Save persists card | Pass | |
| Restart restores card | Pass | |
| Editing draft invalidates card | Pass | |
| Leaving preview keeps old card | Pass | |

## Privacy and Fallback Checks

| Check | Result | Notes |
|---|---|---|
| Stored teacher nickname not sent | Pass | |
| Stored learner nickname not sent | Pass | |
| Context photo not sent | Pass | |
| Photo path not sent | Pass | |
| Reviewed explanation sent only after action | Pass | |
| Airplane Mode creates Offline Guide | Pass | |
| Offline origin is visible | Pass | |
| Offline Guide saves locally | Pass | |
| Local draft survives AI failure | Pass | |

## Evidence

- `screenshots/day-08/card_consent_en.png`
- `screenshots/day-08/card_generating_en.png`
- `screenshots/day-08/card_ai_en.png`
- `screenshots/day-08/home_card_ready.png`

## Limitations

- A name typed manually inside the reviewed explanation is part of the sent text.
- Generated card fields are reviewed but are not individually editable in Day 8.
- One card is stored at a time.
- Context photos remain excluded from AI requests.

## Result

Day 8 passed after automated tests, English and Arabic structured generation,
Offline Guide validation, local persistence, restart restoration, privacy
review, and Figma comparison.