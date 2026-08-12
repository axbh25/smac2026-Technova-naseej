# Naseej | نسيج

Naseej is a bilingual English–Arabic mobile application being developed for
SMAC 2026.

The product helps family members from different generations teach one another
practical, cultural, and digital skills. A family member explains a skill,
may add one private context photo, and can transform the reviewed explanation
into a three-step learning card.

## Current Development Status

Day 8 structured skill card:

- Android-only Flutter project runs on Pixel 7 Pro API 36
- English and Arabic localization is generated from ARB files
- Profile, language, draft, context photo, and card persist locally
- Short speech transcription remains editable
- Context photos remain in private local app storage
- Firebase AI Logic and Firebase App Check are configured
- AI generation requires explicit user action
- The AI request includes reviewed explanation, roles, category, and language
- Stored nicknames and context photos are excluded from the request
- Gemini structured output is constrained by a response schema
- Runtime validation requires exactly three steps
- Cards contain a safety note, teach-back question, and reciprocal suggestion
- AI output is reviewed before it is saved
- Cloud failure creates a clearly labeled Offline Guide
- Offline Guides do not call Firebase AI
- Editing the source draft invalidates the old card
- Saved cards survive restart
- Automated model, generation, persistence, fallback, RTL, and existing-feature tests are included
- Day 2 through Day 8 evidence is stored under `docs/testing/`
- Learner completion, teach-back response, text-to-speech, and notifications are not yet implemented

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
- Provider
- SharedPreferencesAsync
- Local JSON serialization
- `speech_to_text`
- `image_picker`
- `path_provider`
- Firebase Core
- Firebase AI Logic
- Firebase App Check
- Structured Gemini response schemas
- Runtime card validation
- Deterministic Offline Guide
- Figma
- Git and GitHub

## Day 8 AI Data Boundary

The production card request sends:

- Reviewed explanation
- Teacher role
- Learner role
- Skill category
- Output language

It does not add:

- Stored teacher nickname
- Stored learner nickname
- Context photo
- Photo path
- Location
- Contacts

A name typed inside the reviewed explanation is part of that text and will be
sent unless the user removes it.

See `docs/ai-usage/ai-data-boundary.md`.

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
