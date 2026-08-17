# Naseej | نسيج

Naseej is a bilingual English–Arabic mobile application being developed for
SMAC 2026.

Naseej helps family members from different generations teach one another
practical, cultural, and digital skills. One family member explains a skill,
may add one private context photo, and may use AI to transform the reviewed
explanation into a safe three-step learning card. The learner practises the
steps, may hear individual steps aloud, explains what they learned, and chooses
one skill to teach in return.

## Current Development Status

Day 12 reliability and demo readiness:

- Android Flutter application runs on the Pixel 7 Pro reference device
- English and Arabic interfaces support RTL
- Profile, language, draft, photo, card, progress, and Family Thread persist locally
- Firebase AI Logic produces structured three-step cards
- Firebase App Check protects Firebase AI requests
- Cloud failure creates a labeled Offline Guide
- AI output requires teacher review before saving
- Learners practise exactly three steps
- Learner progress and teach-back remain local
- Spoken playback remains optional
- Completed learners choose one return skill
- Family Thread completion remains local
- Invalid local data is repaired layer by layer
- Valid upstream data is preserved
- Storage-service failure is shown separately
- Multi-layer writes use best-effort rollback
- Demo & Local Data tools are available from Welcome and app bars
- AI-ready sample data contains no generated result
- Completed sample data uses a clearly labeled Offline Guide
- Reset removes the local family journey while preserving language
- Current context photos are deleted during replacement when possible
- GitHub Actions verifies formatting, analysis, tests, and Android build
- Fresh-install, Airplane Mode, large-font, and physical-phone checks are documented
- Visual and device evidence is stored under `docs/testing/`

## Team Technova

- Abdullah Haider — Flutter development, architecture, testing, documentation, and demo
- Shoug Almaashari — historical Figma, documentation, bilingual review, and testing contributions

Team membership and contribution records must match the officially registered
competition team. No person is credited for work they did not perform.

## Current MVP Flow

1. Create a local family profile
2. Create a Teach-a-skill draft
3. Type or dictate the explanation
4. Optionally add one private context photo
5. Generate a card or use an Offline Guide
6. Review and save the three-step card
7. Practise each step
8. Optionally hear one step aloud
9. Answer the teach-back question
10. Complete the family lesson
11. Choose one skill to teach in return
12. Complete the reciprocal Family Thread

## What Makes Naseej Different

```text
One generation teaches
→ AI structures the reviewed explanation
→ another generation practises
→ the learner explains it back
→ the learner chooses what to teach in return
→ a reciprocal Family Thread is completed
```

The teacher remains the authority over family knowledge. AI acts only as a
structuring assistant.

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
- Reciprocal Family Thread
- Controlled local-data recovery
- Best-effort write rollback
- GitHub Actions
- Figma
- Git and GitHub

## AI Data Boundary

The skill-card request sends:

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
- Return-skill response
- Completion timestamps
- Playback state

A personal detail typed inside the reviewed explanation is part of that text
and will be sent unless the user removes it.

Learner practice, spoken playback, Family Thread completion, local recovery,
and Demo & Local Data tools make no Firebase AI request.

See `docs/ai-usage/ai-data-boundary.md`.

## Transparent Demo Samples

### AI-ready sample

Contains:

- Local profile
- Local reviewed draft
- No generated card
- No learner progress

The user must still start the normal real AI generation action.

### Completed offline sample

Contains:

- Local profile
- Local draft
- Clearly labeled Offline Guide
- Completed learner progress
- Completed Family Thread

It is not presented as live AI output.

## Local Recovery

Naseej validates the stored journey in dependency order:

```text
Profile
→ Draft
→ Card
→ Learner progress
→ Family Thread
```

When a later layer is invalid, valid earlier layers are preserved and invalid
dependent data is cleared.

## Run the Project

```bash
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
flutter run
```

## Build Android APKs

```bash
flutter build apk --debug
flutter build apk --release
```

Expected paths:

```text
build/app/outputs/flutter-apk/app-debug.apk
build/app/outputs/flutter-apk/app-release.apk
```

## Automated GitHub Checks

The workflow in `.github/workflows/flutter-checks.yml` runs:

```text
Dependency installation
Localization generation
Dart formatting check
Flutter analysis
Automated tests
Android debug APK build
```

## Reference Device

- Pixel 7 Pro
- Android API 36
- Approximately 412 × 892 logical pixels
- Portrait orientation

## Development Evidence

- `docs/development-logs/`
- `docs/meeting-minutes/`
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

- No unnecessary account
- No location tracking
- No public family feed
- No advertising
- No audio-file storage
- Context photos remain local
- Context photos are not sent to AI
- Users explicitly start AI generation
- Generated cards require human review
- Learner progress remains local
- Teach-back responses remain local
- Return-skill responses remain local
- Spoken playback is optional
- Offline Guides remain distinguishable from AI output
- Demo samples are clearly labeled
- Local recovery makes no cloud request