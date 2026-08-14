# Naseej Runtime AI and Local Data Boundary

## Day 7 Connectivity Check

The Day 7 readiness request sent only:

`Return exactly NASEEJ_READY.`

## Day 8 Skill Card Request

The skill-card generation request sends:

- Reviewed teacher explanation
- Teacher family role
- Learner family role
- Skill category
- Selected output language

## Data Not Added to the AI Request

- Stored teacher nickname
- Stored learner nickname
- Context photo
- Context-photo path
- Location
- Contacts
- Email
- Password
- Completed step indexes
- Teach-back response
- Return-skill response
- Lesson completion timestamp
- Family Thread completion timestamp
- Text-to-speech playback state

## Important Limitation

A name or other personal detail typed manually inside the reviewed explanation
is part of that explanation and will be sent unless the user removes it before
generation.

## Local-Only Data

- Profile
- Stored nicknames
- Selected language
- Skill draft
- Speech-recognized text before AI generation
- Context photo
- Saved SkillCard JSON
- Completed step indexes
- Teach-back response
- Return-skill response
- Lesson completion timestamp
- Family Thread completion timestamp
- SkillCard fingerprint

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

## Learner Practice

Learner practice makes no Firebase AI request.

The following remains local:

- Step completion
- Teach-back response
- Lesson completion state

## Spoken Playback

Spoken playback makes no Firebase AI request.

- Naseej does not record audio
- Naseej does not store an audio file
- Naseej does not upload audio
- Playback uses the Android device's installed text-to-speech service
- Playback state is temporary and is not persisted

## Reciprocal Family Thread

Completing a Family Thread makes no Firebase AI request.

The return-skill response and Family Thread completion timestamp remain local.

The reciprocal suggestion displayed in the Family Thread is copied from the
already reviewed SkillCard. It is not generated again during Day 11.