# Naseej | نسيج

Naseej is a bilingual English–Arabic mobile application being developed for
SMAC 2026.

Naseej helps family members from different generations teach one another
practical, cultural, and digital skills. A family member explains a skill,
may add one private context photo, and can use AI to transform the reviewed
explanation into a safe three-step learning card. The learner can practise the
steps, hear individual steps aloud, and explain what they learned.

## Current Development Status

Day 10 accessible spoken playback:

- Android-only Flutter project runs on Pixel 7 Pro API 36
- English and Arabic interfaces support RTL
- Profile, language, draft, photo, card, and progress persist locally
- Teacher explanations support typed or short speech input
- Context photos remain in private local app storage
- Firebase AI Logic produces structured three-step cards
- Firebase App Check protects Firebase AI requests
- Structured output is validated before display or storage
- Cloud failure creates a labeled Offline Guide
- AI output requires teacher review before saving
- Learners practise exactly three saved steps
- Learner progress and teach-back remain local
- Learners can hear one approved step at a time
- Listen, Stop, and Replay actions are visibly labeled
- The saved card language selects the speech language
- Only one step can play at a time
- Leaving the learner screen stops playback
- Speech failure does not block reading, progress, or teach-back
- No audio file is recorded or stored
- Day 10 adds no Firebase AI request
- Automated TTS controller, cancellation, fallback, widget, and RTL tests are included
- Visual and device evidence is stored under `docs/testing/`

## Team Technova

- Abdullah Haider — Flutter development, architecture, testing, documentation, and demo
- Shoug Almaashari — historical Figma, documentation, bilingual review, and testing contributions

Team membership and contribution records must match the officially registered
competition team. No person is credited for work they did not perform.

## Current MVP Flow

1. Create a local family profile
2. Create a Teach-a-Skill draft
3. Type or dictate the explanation
4. Optionally add one private context photo
5. Generate a card or use an Offline Guide
6. Review and save the three-step card
7. Practise each step
8. Optionally hear a step aloud
9. Answer the teach-back question
10. Complete the family lesson
11. See the reciprocal skill suggestion

## Technology

- Flutter and Dart
- Android
- Provider
- SharedPreferencesAsync
- Local JSON serialization
- `speech_to_text`
- `flutter_tts`
- `image_picker`
- `path_provider`
- Firebase Core
- Firebase AI Logic
- Firebase App Check
- Structured Gemini response schemas
- Runtime card validation
- Deterministic Offline Guide
- Local learner progress
- Device text-to-speech
- Figma
- Git and GitHub

## AI Data Boundary

The card-generation request sends:

- Reviewed explanation
- Teacher role
- Learner role
- Skill category
- Output language

It does not add:

- Stored nicknames
- Context photo
- Photo path
- Location
- Contacts
- Learner progress
- Teach-back response
- Playback state

A personal detail typed inside the reviewed explanation is part of that text
and will be sent unless the user removes it.

Learner practice and spoken playback add no Firebase AI request.

## Spoken Playback Boundary

- Playback uses the device's installed Android TTS service
- Naseej does not record audio
- Naseej does not store audio files
- Naseej does not upload audio
- Device voice availability varies by language and installed engine
- The lesson remains usable when speech is unavailable

See `docs/ai-usage/ai-data-boundary.md`.

## Run the Project

```bash
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
flutter run


```bash
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
flutter run


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
