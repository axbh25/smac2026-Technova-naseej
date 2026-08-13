# Day 9 Learner Practice Verification

**Date:** 2026-08-15  
**Branch:** `feature/day-09-learner-practice`  
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
| LearningProgress JSON round trip | Pass | |
| Invalid completion rejection | Pass | |
| Duplicate-step rejection | Pass | |
| Exact-card fingerprint matching | Pass | |
| Progress restoration | Pass | |
| Card replacement clears progress | Pass | |
| Draft editing clears progress | Pass | |
| Widget completion flow | Pass | |
| Partial-progress restoration | Pass | |
| Arabic RTL | Pass | |

## Real Device Checks

| Check | Result | Notes |
|---|---|---|
| Learning locked without card | Pass | |
| Start Learning opens screen | Pass | |
| Exactly three steps shown | Pass | |
| Step 1 saves immediately | Pass | |
| Step 2 saves immediately | Pass | |
| Step 3 saves immediately | Pass | |
| Progress count updates | Pass | |
| Progress survives restart | Pass | |
| Teach-back minimum enforced | Pass | |
| Teach-back survives restart | Pass | |
| Completion requires all fields | Pass | |
| Completion banner appears | Pass | |
| Completed state survives restart | Pass | |
| Regenerated card clears progress | Pass | |
| Edited draft clears progress | Pass | |
| Airplane Mode works | Pass | |
| No Day 9 cloud request | Pass | |

## Evidence

- `screenshots/day-09/learning_start_en.png`
- `screenshots/day-09/learning_partial_en.png`
- `screenshots/day-09/learning_complete_en.png`

## Limitations

- Only one active lesson is stored in the MVP.
- The teach-back response is typed rather than recorded.
- Progress exists on one phone only.
- Day 9 does not synchronize progress between family members.
- Notifications are deferred.

## Result

Day 9 passed