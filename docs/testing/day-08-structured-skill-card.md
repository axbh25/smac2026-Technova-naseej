# Day 8 Structured Skill Card Verification

**Date:** 2026-08-14  
**Branch:** `feature/day-08-structured-skill-card`  
**Reference device:** Pixel 7 Pro, Android API 36  
**Reference viewport:** 412 × 892

## Automated Checks

| Check | Result | Notes |
|---|---|---|
| `flutter pub get` | Pass / Fail | |
| `flutter gen-l10n` | Pass / Fail | |
| Dart formatting | Pass / Fail | |
| `flutter analyze` | Pass / Fail | |
| `flutter test` | Pass / Fail | |
| SkillCard JSON round trip | Pass / Fail | |
| Exactly-three-step validation | Pass / Fail | |
| AI model-name validation | Pass / Fail | |
| Draft-fingerprint validation | Pass / Fail | |
| AI generation controller success | Pass / Fail | |
| Automatic Offline Guide | Pass / Fail | |
| Manual Offline Guide avoids cloud | Pass / Fail | |

## Real AI Checks

| Check | Result | Notes |
|---|---|---|
| Explicit generation action | Pass / Fail | |
| English AI card | Pass / Fail | |
| Arabic AI card | Pass / Fail | |
| Exactly three steps | Pass / Fail | |
| Safety note present | Pass / Fail | |
| Teach-back question present | Pass / Fail | |
| Reciprocal suggestion present | Pass / Fail | |
| Origin label correct | Pass / Fail | |
| Model label correct | Pass / Fail | |
| Preview is not auto-saved | Pass / Fail | |
| Save persists card | Pass / Fail | |
| Restart restores card | Pass / Fail | |
| Editing draft invalidates card | Pass / Fail | |
| Leaving preview keeps old card | Pass / Fail | |

## Privacy and Fallback Checks

| Check | Result | Notes |
|---|---|---|
| Stored teacher nickname not sent | Pass / Fail | |
| Stored learner nickname not sent | Pass / Fail | |
| Context photo not sent | Pass / Fail | |
| Photo path not sent | Pass / Fail | |
| Reviewed explanation sent only after action | Pass / Fail | |
| Airplane Mode creates Offline Guide | Pass / Fail | |
| Offline origin is visible | Pass / Fail | |
| Offline Guide saves locally | Pass / Fail | |
| Local draft survives AI failure | Pass / Fail | |

## Evidence

- `screenshots/day-08/card_consent_en.png`
- `screenshots/day-08/card_generating_en.png`
- `screenshots/day-08/card_ai_en.png`
- `screenshots/day-08/card_offline_en.png`
- `screenshots/day-08/card_ai_ar.png`
- `screenshots/day-08/home_card_ready.png`

## Limitations

- A name typed manually inside the reviewed explanation is part of the sent text.
- Generated card fields are reviewed but are not individually editable in Day 8.
- One card is stored at a time.
- Context photos remain excluded from AI requests.

## Result

Day 8 passed / requires correction.