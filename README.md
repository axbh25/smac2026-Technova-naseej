# Naseej | نسيج

Naseej is a bilingual English–Arabic mobile application being developed for
SMAC 2026.

Naseej helps family members from different generations teach one another
practical, cultural, and digital skills. One family member explains a skill,
may add one private context photo, and can use AI to transform the reviewed
explanation into a safe three-step learning card. The learner practises the
steps, may hear each step aloud, explains what they learned, and chooses one
skill to teach in return.

## Current Development Status

Day 11 reciprocal Family Thread:

- Android Flutter application runs on the Pixel 7 Pro reference device
- English and Arabic interfaces support RTL
- Profile, language, draft, photo, card, progress, and Family Thread persist locally
- Teacher explanations support typed or short speech input
- Context photos remain in private local app storage
- Firebase AI Logic produces structured three-step cards
- Firebase App Check protects Firebase AI requests
- Structured output is validated before display or storage
- Cloud failure creates a labeled Offline Guide
- AI output requires teacher review before saving
- Learners practise exactly three saved steps
- Learners may hear one approved step at a time
- Learner progress and teach-back remain local
- Lesson completion requires all three steps and teach-back
- Completed learners choose one skill to teach in return
- Naseej's reciprocal suggestion may be copied and edited
- Family Thread completion requires explicit user action
- Completed Family Threads survive Android restart
- Relevant edits invalidate stale completion
- Day 11 works in Airplane Mode
- Day 11 adds no Firebase AI request
- Automated compatibility, persistence, invalidation, widget, and RTL tests are included
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
11. Choose one skill to teach in return
12. Complete the reciprocal Family Thread

## What Makes Naseej Different

Naseej does not stop at generating content.

It supports a reciprocal family interaction:

```text
One generation teaches
→ AI structures the explanation
→ another generation practises
→ the learner explains it back
→ the learner chooses what to teach in return
→ a Family Thread is completed
```

The teacher remains the authority over the family knowledge, while AI acts only
as a structuring assistant.

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
- Figma
- Git and GitHub

## AI Data Boundary

The skill-card request sends:

- Reviewed explanation
- Teacher role
- Learner role
- Skill category
- Output language

It does not send:

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

Learner practice, spoken playback, and Family Thread completion add no Firebase
AI request.

See `docs/ai-usage/ai-data-boundary.md`.

## Spoken Playback Boundary

- Playback uses the device's installed Android TTS service
- Naseej does not record audio
- Naseej does not store audio files
- Naseej does not upload audio
- Device voice availability varies
- The lesson remains usable when speech is unavailable

## Family Thread Boundary

- Return-skill responses remain local
- Family Thread completion timestamps remain local
- The reciprocal suggestion comes from the reviewed SkillCard
- Day 11 does not call AI again
- The MVP stores one active Family Thread

## Run the Project

```bash
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
flutter run
```

## Build the Android Debug APK

```bash
flutter build apk --debug
```

The APK is created at:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

## Reference Device

- Pixel 7 Pro
- Android API 36
- Approximately 412 × 892 logical pixels
- Portrait orientation

## Figma

English and Arabic screens are reviewed separately against the Pixel 7 Pro
reference frame.

See `docs/design/figma-handoff.md`.

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

The team remains responsible for implementing, testing, reviewing, and
understanding the application and must be able to explain its architecture,
data flow, privacy boundaries, and design decisions during competition Q&A.

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
- Family Thread completion remains local
- Day 11 adds no additional AI request

Naseej is designed so that AI supports the family interaction rather than
replacing it.