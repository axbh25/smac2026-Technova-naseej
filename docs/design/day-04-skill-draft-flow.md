# Naseej Day 4 Skill Draft Flow

## Reference Device

- Pixel 7 Pro
- 412 × 892 Flutter logical pixels
- Android API 36
- Portrait orientation

## Approved Frames

- `04_TeachSkill_EN`
- `04_TeachSkill_AR`
- `05_HomeDraft_EN`
- `05_HomeDraft_AR`

## Teach Skill Layout

- App bar: 56
- Horizontal padding: 24
- Teacher card minimum height: 80
- Learner field height: 56
- Role card size: 176 × 108
- Category card size: 176 × 96
- Grid gap: 12
- Explanation minimum height: 160
- Save button height: 56
- Main content scrolls behind a fixed bottom action

## Draft Fields

- Teacher nickname
- Teacher family role
- Learner nickname
- Learner family role
- Skill category
- Typed explanation

## Categories

| Storage value | English | Arabic |
|---|---|---|
| `heritage` | Heritage & Etiquette | التراث والآداب |
| `everyday` | Everyday Skill | مهارة يومية |
| `digital` | Digital Confidence | الثقة الرقمية |
| `familyCare` | Family Care | الرعاية العائلية |

## Validation

- Learner nickname is required
- Learner role is required
- Category is required
- Explanation requires at least 20 characters
- Explanation maximum is 600 characters

## RTL Rules

- Back arrow follows the active direction
- Teacher and learner summaries follow RTL in Arabic
- Category-card order remains semantically consistent
- Text fields align to the active locale
- Non-directional icons are not mirrored

## Deferred Features

- Microphone
- Speech recognition
- Camera
- Photos
- AI skill-card generation
