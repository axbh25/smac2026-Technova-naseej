# Naseej Runtime AI Data Boundary

## Day 7 Connectivity Check

The Day 7 AI request sends only:

`Return exactly NASEEJ_READY.`

## Day 7 Data Not Sent

- Teacher nickname
- Teacher role
- Learner nickname
- Learner role
- Skill category
- Draft explanation
- Speech transcript
- Context photo
- Photo path
- Location
- Contacts
- Email
- Password

## Local-Only Data

The following remains on the phone during Day 7:

- Profile
- Selected language
- Skill draft
- Speech-recognized text
- Context photo

## Future Change Control

Before a later feature sends reviewed draft text to AI:

1. The exact prompt must be documented.
2. The user-facing consent wording must be approved.
3. Structured-output validation must be implemented.
4. Offline fallback must remain available.
5. Context photos must remain excluded from the MVP AI request.