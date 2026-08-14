# Day 10 Spoken Step Playback Verification

**Date:** 16-08-2026  
**Branch:** `feature/day-10-spoken-playback`  
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
| Debug APK build | Pass / Fail | |
| TTS controller success | Pass / Fail | |
| TTS language unavailable | Pass / Fail | |
| TTS stop cancellation | Pass / Fail | |
| TTS speaking failure | Pass / Fail | |
| Listen-to-Stop UI | Pass / Fail | |
| Replay UI | Pass / Fail | |
| Learning remains usable without TTS | Pass / Fail | |
| Card language selects speech | Pass / Fail | |
| Arabic RTL | Pass / Fail | |

## Android Device Checks

| Check | Result | Notes |
|---|---|---|
| Preferred TTS engine identified | Pass / Fail | |
| English voice installed | Pass / Fail | |
| Arabic voice installed or limitation documented | Pass / Fail | |
| English Step 1 spoken | Pass / Fail | |
| English Step 2 spoken | Pass / Fail | |
| English Step 3 spoken | Pass / Fail | |
| Stop ends playback | Pass / Fail | |
| Replay repeats exact step | Pass / Fail | |
| Only one step plays at once | Pass / Fail | |
| Screen exit stops playback | Pass / Fail | |
| Completion stops playback | Pass / Fail | |
| Airplane Mode tested | Pass / Fail | |
| Checkboxes work after TTS failure | Pass / Fail | |
| Teach-back works after TTS failure | Pass / Fail | |

## Privacy Checks

| Check | Result | Notes |
|---|---|---|
| No audio file recorded | Pass / Fail | |
| No audio file stored | Pass / Fail | |
| No cloud TTS service added | Pass / Fail | |
| No lesson text added to Firebase request | Pass / Fail | |
| Device-service notice visible | Pass / Fail | |
| Speech unavailability is non-blocking | Pass / Fail | |

## Evidence

- `screenshots/day-10/spoken_idle_en.png`
- `screenshots/day-10/spoken_playing_en.png`
- `screenshots/day-10/spoken_replay_en.png`
- `screenshots/day-10/spoken_unavailable_en.png`
- `screenshots/day-10/spoken_idle_ar.png`
- `screenshots/day-10/spoken_playing_ar.png`

## Limitations

- Voice quality depends on the installed Android TTS engine.
- Arabic voice data may not be installed on every device.
- Some device voices may require prior downloading.
- Playback is not stored or resumed after closing the screen.
- The MVP does not provide voice or speed customization.

## Result

Day 10 passed / requires correction.