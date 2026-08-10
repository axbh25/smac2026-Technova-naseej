# Day 3 Profile Persistence Verification

**Date:** 2026-08-08  
**Branch:** `feature/day-03-profile-persistence`  
**Reference device:** Pixel 7 Pro, Android API 36  
**Reference viewport:** 412 × 892

## Automated Checks

| Check | Result | Notes |
|---|---|---|
| `flutter gen-l10n` | Pass | |
| Dart formatting | Pass | |
| `flutter analyze` | Pass | |
| `flutter test` | Pass | |
| Profile JSON round trip | Pass | |
| Invalid JSON rejection | Pass | |
| Nickname requirement | Pass | |
| Role requirement | Pass | |
| Save-to-Home flow | Pass | |
| Stored Arabic-profile restoration | Pass | |
| Accessibility guidelines | Pass | |

## Real Android Checks

| Check | Result | Notes |
|---|---|---|
| English Profile Setup opens | Pass | |
| Arabic Profile Setup opens | Pass | |
| Arabic Profile Setup uses RTL | Pass | |
| Profile saves without internet | Pass | |
| Locale survives process restart | Pass | |
| Profile survives process restart | Pass | |
| Saved profile skips onboarding | Pass | |
| Keyboard causes no inaccessible content | Pass | |
| No overflow at 412 × 892 | Pass | |
| English Figma overlays reviewed | Pass | |
| Arabic Figma overlays reviewed | Pass | |

## Evidence

- `screenshots/day-03/profile_setup_en.png`
- `screenshots/day-03/profile_setup_ar.png`
- `screenshots/day-03/home_en.png`
- `screenshots/day-03/home_ar.png`

## Differences Remaining

No blocking visual difference remained at the 412 × 892 reference viewport.
Small platform-specific differences in font rasterization may remain between
Figma and the Android emulator.

## Result

Day 3 passed after automated tests, English and Arabic device checks,
persistence verification, restart restoration, and visual comparison.
