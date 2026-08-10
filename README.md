# Naseej | نسيج

Naseej is a bilingual English–Arabic mobile application being developed for
SMAC 2026.

The planned product helps family members from different generations teach one
another practical, cultural, and digital skills. A family member will explain
a skill using voice or text, and AI will help restructure the approved
explanation into a short three-step learning card. The learner will complete
the activity and then be encouraged to teach a skill in return.

## Current Development Status

Day 5 editable speech transcription:

- Android-only Flutter project runs on Pixel 7 Pro API 36
- English and Arabic localization is generated from ARB files
- A local profile and selected language persist after restart
- One bilingual Teach-a-Skill draft persists locally
- Learner nickname, role, category, and explanation are restored
- English and Arabic short speech transcription is integrated
- Voice input has visible Idle, Listening, and Fallback states
- Recognized words appear in the editable explanation field
- Existing typed text is preserved when voice input begins
- Manual typing remains available after permission or service failure
- Naseej stores recognized text but does not save an audio file
- The device speech service may require internet access
- Automated speech-controller, fallback, persistence, RTL, and accessibility tests are included
- Day 2 through Day 5 visual evidence is stored under `docs/testing/`
- Camera input, production AI generation, skill cards, and notifications are not yet implemented

## Current Developer
- GitHub: axbh25
- Role: product design, Flutter development, testing, documentation, and demo

## Team Technova

- Abdullah Haider — Flutter development, architecture, testing, and documentation
- Shoug Almaashari — Figma, documentation, testing

Both participants use their own GitHub accounts and must understand every
merged feature.

## Planned MVP

1. Voice or typed skill explanation
2. AI-assisted three-step learning card
3. Learner completion and teach-back
4. Reciprocal skill suggestion
5. English and Arabic interface with RTL support
6. Local storage and transparent offline fallback

## Technology
- Provider for shared application state
- SharedPreferencesAsync for small non-critical local preferences
- Flutter and Dart
- Android
- Figma
- Git and GitHub
- Local JSON serialization for the current skill draft
Camera, production AI generation, and notifications will be added gradually
only when the relevant feature is implemented and tested.
- `speech_to_text` for short user-initiated device speech recognition
- A testable speech-engine abstraction with a shared SpeechController
## Android Reference Device

- Hardware profile: Pixel 7 Pro
- Android system image: API 36
- Physical profile: 1440 × 3120 at 560 dpi
- Approximate Flutter logical size: 412 × 892
- Orientation: Portrait

## Run the Current Project

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## Figma

Design file: https://www.figma.com/design/RXh2fTPhOhP317qzky4pKE/Naseej-%E2%80%94-SMAC-2026?node-id=0-1&t=FKwfnrCDavmYx0M6-1

Primary reference frame:

- Pixel 7 Pro
- 412 × 892 logical pixels
- English and Arabic screens are reviewed separately

See `docs/design/figma-handoff.md`.

## Development Evidence

Evidence is stored in:

- `docs/development-logs/`
- `docs/testing/`
- `docs/design/`
- `docs/ai-usage/`
- `docs/competition/`

## AI-Assisted Development

AI is used only for documented planning, explanations, isolated code
assistance, wording drafts, and debugging support.

AI is not used to generate the complete application.

Every meaningful prompt and contribution is recorded in
`docs/ai-usage/development-ai-log.md`.

## Privacy Direction

The planned MVP will avoid unnecessary accounts, location tracking, public
feeds, advertising, and cloud photo storage.
