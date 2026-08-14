# Naseej Day 10 Spoken Step Playback

## Reference Device

- Pixel 7 Pro
- Android API 36
- 412 × 892 logical pixels
- Portrait orientation

## Approved English Frames

- `26_SpokenStepsIdle_EN`
- `27_SpokenStepPreparing_EN`
- `28_SpokenStepPlaying_EN`
- `29_SpokenStepReplay_EN`
- `30_SpokenUnavailable_EN`

## Approved Arabic Frames

- `26_SpokenStepsIdle_AR`
- `27_SpokenStepPreparing_AR`
- `28_SpokenStepPlaying_AR`
- `29_SpokenStepReplay_AR`
- `30_SpokenUnavailable_AR`

## Playback Rules

1. Speech is optional.
2. One step is spoken at a time.
3. The saved card language selects the speech language.
4. The current UI language does not change card content.
5. A visible Stop action is always available during playback.
6. Replay appears after an utterance finishes.
7. Leaving the learner screen stops playback.
8. Speech does not alter learning progress.
9. Speech failure does not block the lesson.

## Privacy Boundary

- No audio is recorded.
- No audio file is stored.
- No lesson text is sent to Firebase for speech.
- No Day 10 data is added to the AI request.
- Playback uses the Android device's installed TTS service.
- Device voice availability may vary.

## Accessibility

- Buttons are at least 48 logical pixels high.
- Every icon has a text label.
- Speech state is communicated by text and icon.
- Checkboxes remain usable without speech.
- Arabic uses RTL.