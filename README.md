# Naseej | نسيج

Naseej is a bilingual English–Arabic mobile application being developed for
SMAC 2026.

Naseej helps family members from different generations teach one another
practical, cultural, and digital skills. A family member explains a skill,
may add one private context photo, and can use AI to transform the reviewed
explanation into a safe three-step learning card. The learner then practises
the steps and explains what they learned.

## Current Development Status

Day 9 learner practice:

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
- Learners can practise exactly three saved steps
- Every checkbox change is saved locally
- Learners answer a teach-back question in their own words
- Completion requires all steps and a valid teach-back response
- Progress and completion survive Android restarts
- Progress is invalidated when the source draft or card changes
- Day 9 learning works fully in Airplane Mode
- No Day 9 progress or teach-back data is sent to AI
- Automated model, storage, invalidation, completion, and RTL tests are included
- Visual evidence is stored under `docs/testing/`

## Team Technova

- Abdullah Haider — Flutter development, architecture, testing, documentation, and demo
- Shoug Almaashari — historical Figma, documentation, bilingual review, and testing contributions

Team membership must match the officially registered competition team.
No person is credited for work they did not perform.

## Current MVP Flow

1. Create a local family profile
2. Create a Teach-a-Skill draft
3. Type or dictate the explanation
4. Optionally add one private context photo
5. Generate or use an Offline Guide
6. Review and save the three-step card
7. Practise each step
8. Answer the teach-back question
9. Complete the family lesson
10. See the reciprocal skill suggestion

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
- Local learner progress
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

A personal detail typed inside the reviewed explanation is part of that text
and will be sent unless the user removes it.

Day 9 learner practice makes no Firebase AI request.

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
