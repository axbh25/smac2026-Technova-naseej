# Day 10 Spoken Step Playback Verification

**Date:** 16-08-2026  
**Branch:** `feature/day-10-spoken-playback`  
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
| Debug APK build | Pass | |
| TTS controller success | Pass | |
| TTS language unavailable | Pass | |
| TTS stop cancellation | Pass | |
| TTS speaking failure | Pass | |
| Listen-to-Stop UI | Pass | |
| Replay UI | Pass | |
| Learning remains usable without TTS | Pass | |
| Card language selects speech | Pass | |
| Arabic RTL | Pass | |

## Android Device Checks

| Check | Result | Notes |
|---|---|---|
| Preferred TTS engine identified | Pass | |
| English voice installed | Pass / Fail | |
| Arabic voice installed or limitation documented | Pass | |
| English Step 1 spoken | Pass | |
| English Step 2 spoken | Pass | |
| English Step 3 spoken | Pass | |
| Stop ends playback | Pass | |
| Replay repeats exact step | Pass | |
| Only one step plays at once | Pass | |
| Screen exit stops playback | Pass | |
| Completion stops playback | Pass | |
| Airplane Mode tested | Pass | |
| Checkboxes work after TTS failure | Pass | |
| Teach-back works after TTS failure | Pass | |

## Privacy Checks

| Check | Result | Notes |
|---|---|---|
| No audio file recorded | Pass | |
| No audio file stored | Pass | |
| No cloud TTS service added | Pass | |
| No lesson text added to Firebase request | Pass | |
| Device-service notice visible | Pass | |
| Speech unavailability is non-blocking | Pass | |

## Evidence

- `screenshots/day-10/spoken_idle_en.png`
- `screenshots/day-10/spoken_playing_en.png`
- `screenshots/day-10/spoken_replay_en.png`

## Limitations

- Voice quality depends on the installed Android TTS engine.
- Arabic voice data may not be installed on every device.
- Some device voices may require prior downloading.
- Playback is not stored or resumed after closing the screen.
- The MVP does not provide voice or speed customization.

## Result

Day 10 passed