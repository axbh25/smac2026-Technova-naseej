# Day 4 Skill Draft Verification

**Date:** 2026-08-10  
**Branch:** `feature/day-04-skill-draft`  
**Reference device:** Pixel 7 Pro, Android API 36  
**Reference viewport:** 412 × 892

## Automated Checks

| Check | Result | Notes |
|---|---|---|
| `flutter gen-l10n` | Pass / Fail | |
| Dart formatting | Pass / Fail | |
| `flutter analyze` | Pass / Fail | |
| `flutter test` | Pass / Fail | |
| SkillDraft JSON round trip | Pass / Fail | |
| Damaged JSON rejection | Pass / Fail | |
| Unknown-category rejection | Pass / Fail | |
| Short-explanation rejection | Pass / Fail | |
| Required-field validation | Pass / Fail | |
| Draft save-to-Home flow | Pass / Fail | |
| Saved-draft restoration | Pass / Fail | |
| Arabic RTL test | Pass / Fail | |

## Real Android Checks

| Check | Result | Notes |
|---|---|---|
| English Teach screen opens | Pass / Fail | |
| Arabic Teach screen opens | Pass / Fail | |
| Arabic Teach screen uses RTL | Pass / Fail | |
| Teacher profile is correct | Pass / Fail | |
| Learner nickname is required | Pass / Fail | |
| Learner role is required | Pass / Fail | |
| Category is required | Pass / Fail | |
| 20-character minimum works | Pass / Fail | |
| 600-character maximum works | Pass / Fail | |
| Draft saves in airplane mode | Pass / Fail | |
| Draft survives restart | Pass / Fail | |
| Continue Draft restores fields | Pass / Fail | |
| No overflow at 412 × 892 | Pass / Fail | |
| English overlays reviewed | Pass / Fail | |
| Arabic overlays reviewed | Pass / Fail | |

## Evidence

- `screenshots/day-04/teach_skill_en.png`
- `screenshots/day-04/teach_skill_ar.png`
- `screenshots/day-04/home_draft_en.png`
- `screenshots/day-04/home_draft_ar.png`

## Differences Remaining

Record any actual difference.

## Result

Day 4 passed / requires correction.
