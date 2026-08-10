# Naseej Day 5 Voice Input

## Reference Device

- Pixel 7 Pro
- Android API 36
- 412 × 892 logical pixels
- Portrait orientation

## Approved Frames

- `06_TeachVoiceIdle_EN`
- `07_TeachVoiceListening_EN`
- `08_TeachVoiceFallback_EN`
- `06_TeachVoiceIdle_AR`
- `07_TeachVoiceListening_AR`
- `08_TeachVoiceFallback_AR`

## Voice Input Component

- Width: 364
- Minimum height: 150
- Padding: 16
- Corner radius: 16
- Microphone control: at least 64 × 64
- Main labeled action height: at least 56
- States: Idle, Listening, Unavailable, Error

## Behavior

1. Tap Start Speaking.
2. Request microphone permission when required.
3. Display a visible listening state.
4. Insert partial recognized words into the explanation field.
5. Stop manually or when the platform stops.
6. Allow the user to edit recognized text.
7. Preserve manual typing as the fallback.

## Privacy

Naseej stores the resulting text only.

Naseej does not save an audio file.

The device speech-recognition service may require internet access and may
process speech through a remote service.

## Deferred

- Continuous listening
- Audio recording
- Bluetooth headset support
- Background recognition
- AI lesson generation