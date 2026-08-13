paste # Day 9 Learner Practice Verification

**Date:** 2026-08-15  
**Branch:** `feature/day-09-learner-practice`  
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
| LearningProgress JSON round trip | Pass / Fail | |
| Invalid completion rejection | Pass / Fail | |
| Duplicate-step rejection | Pass / Fail | |
| Exact-card fingerprint matching | Pass / Fail | |
| Progress restoration | Pass / Fail | |
| Card replacement clears progress | Pass / Fail | |
| Draft editing clears progress | Pass / Fail | |
| Widget completion flow | Pass / Fail | |
| Partial-progress restoration | Pass / Fail | |
| Arabic RTL | Pass / Fail | |

## Real Device Checks

| Check | Result | Notes |
|---|---|---|
| Learning locked without card | Pass / Fail | |
| Start Learning opens screen | Pass / Fail | |
| Exactly three steps shown | Pass / Fail | |
| Step 1 saves immediately | Pass / Fail | |
| Step 2 saves immediately | Pass / Fail | |
| Step 3 saves immediately | Pass / Fail | |
| Progress count updates | Pass / Fail | |
| Progress survives restart | Pass / Fail | |
| Teach-back minimum enforced | Pass / Fail | |
| Teach-back survives restart | Pass / Fail | |
| Completion requires all fields | Pass / Fail | |
| Completion banner appears | Pass / Fail | |
| Completed state survives restart | Pass / Fail | |
| Regenerated card clears progress | Pass / Fail | |
| Edited draft clears progress | Pass / Fail | |
| Airplane Mode works | Pass / Fail | |
| No Day 9 cloud request | Pass / Fail | |

## Evidence

- `screenshots/day-09/learning_start_en.png`
- `screenshots/day-09/learning_partial_en.png`
- `screenshots/day-09/learning_ready_en.png`
- `screenshots/day-09/learning_complete_en.png`
- `screenshots/day-09/learning_partial_ar.png`
- `screenshots/day-09/home_learning_progress.png`

## Limitations

- Only one active lesson is stored in the MVP.
- The teach-back response is typed rather than recorded.
- Progress exists on one phone only.
- Day 9 does not synchronize progress between family members.
- Notifications are deferred.

## Result

Day 9 passed / requires correction.