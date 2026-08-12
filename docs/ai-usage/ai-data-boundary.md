# Naseej Runtime AI Data Boundary

## Day 7 Connectivity Check

The Day 7 readiness request sent only:

`Return exactly NASEEJ_READY.`

## Day 8 Skill Card Request

The Day 8 generation request sends:

- Reviewed teacher explanation
- Teacher family role
- Learner family role
- Skill category
- Selected output language

## Data Not Added to the Request

- Stored teacher nickname
- Stored learner nickname
- Context photo
- Context-photo path
- Location
- Contacts
- Email
- Password

## Important Limitation

A name or other personal detail typed manually inside the reviewed explanation
is part of that explanation and will be sent unless the user removes it before
generation.

## Local-Only Data

- Profile
- Stored nicknames
- Selected language
- Skill draft
- Speech-recognized text before generation
- Context photo
- Saved SkillCard JSON

## Review and Save

AI output is not automatically saved.

The teacher reviews:

1. Title
2. Three steps
3. Safety note
4. Teach-back question
5. Reciprocal skill suggestion

The card is saved only after the teacher taps `Save 3-Step Card`.

## Offline Guide

When cloud generation fails, or when the user chooses it manually, Naseej
creates a deterministic local Offline Guide.

The Offline Guide:

- Does not call Firebase AI
- Is labeled as `Offline Guide`
- Is not described as AI-generated
- Can be reviewed and saved locally

## Context Photo

The context photo is not sent to Firebase AI Logic in the MVP.