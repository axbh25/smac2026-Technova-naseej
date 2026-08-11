# Naseej | نسيج

Naseej is a bilingual English–Arabic mobile application being developed for
SMAC 2026.

The product helps family members from different generations teach one another
practical, cultural, and digital skills. A family member explains a skill
using voice or text, may add one private context photo, and will later use AI
to restructure the approved explanation into a short three-step learning
card.

## Current Development Status

Day 6 private context photo:

- Android-only Flutter project runs on Pixel 7 Pro API 36
- English and Arabic localization is generated from ARB files
- A local profile and selected language persist after restart
- One bilingual Teach-a-Skill draft persists locally
- Learner nickname, role, category, and explanation are restored
- Short English and Arabic speech transcription is integrated
- Recognized speech remains editable
- Manual typing remains available after speech failure
- One optional context photo can be captured or selected
- Selected photos are copied into private app storage
- Context photos appear in the Teach Skill form and Home draft
- Context photos survive application restart
- Photos can be replaced or removed
- Android lost picker data is handled
- Naseej stores recognized text but does not save audio
- Naseej keeps context photos local and does not send them to AI in the MVP
- Automated model, speech, photo, persistence, RTL, and accessibility tests are included
- Day 2 through Day 6 visual evidence is stored under `docs/testing/`
- Production AI generation, skill cards, teach-back, and notifications are not yet implemented

## Current Developer

- GitHub: axbh25
- Role: product design, Flutter development, testing, documentation, and demo

## Team Technova

- Abdullah Haider — Flutter development, architecture, testing, and documentation
- Shoug Almaashari — Figma, documentation, bilingual review, and testing

Both participants use their own GitHub accounts and must understand every
merged feature.

## Planned MVP

1. Voice or typed skill explanation
2. Optional private context photo
3. AI-assisted three-step learning card
4. Learner completion and teach-back
5. Reciprocal skill suggestion
6. English and Arabic interface with RTL support
7. Local storage and transparent offline fallback

## Technology

- Flutter and Dart
- Android
- Provider for shared application state
- SharedPreferencesAsync for small non-critical local preferences
- Local JSON serialization for the current skill draft
- `speech_to_text` for short user-initiated device speech recognition
- A testable speech-engine abstraction with a shared SpeechController
- `image_picker` for camera and gallery image selection
- `path_provider` for private application file locations
- A testable context-photo service abstraction
- Figma
- Git and GitHub

Production AI generation and notifications will be added gradually only when
the relevant feature is implemented and tested.

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
