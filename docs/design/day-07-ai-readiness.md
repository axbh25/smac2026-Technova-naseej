# Naseej Day 7 AI Readiness

## Reference Device

- Pixel 7 Pro
- Android API 36
- 412 × 892 logical pixels
- Portrait orientation

## Approved Frames

- `12_HomeAiIdle_EN`
- `13_HomeAiChecking_EN`
- `14_HomeAiReady_EN`
- `15_HomeAiUnavailable_EN`
- `12_HomeAiIdle_AR`
- `13_HomeAiChecking_AR`
- `14_HomeAiReady_AR`
- `15_HomeAiUnavailable_AR`

## AI Readiness Card

- Width: 364
- Minimum height: 180
- Padding: 16
- Gap: 12
- Corner radius: 16
- Main action height: 56
- States: Idle, Checking, Ready, Unavailable

## Day 7 Request

The readiness service sends one fixed request only:

`Return exactly NASEEJ_READY.`

## Data Not Sent

- Profile nickname
- Profile role
- Learner nickname
- Learner role
- Skill category
- Draft explanation
- Speech transcript
- Context photo
- Location
- Contacts

## Offline Behavior

The AI readiness check may fail without internet.

All existing local features remain available:

- Profile
- Language
- Draft
- Speech transcript
- Context photo
- Draft editing

## Deferred

- Production lesson generation
- Structured JSON output
- AI use of family text
- AI use of context photos
- Completed lesson cards