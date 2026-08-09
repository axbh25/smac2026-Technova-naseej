# Naseej Day 3 Profile and Home Flow

## Reference Device

- Pixel 7 Pro
- 412 × 892 Flutter logical pixels
- Android API 36
- Portrait orientation

## Approved Frames

- `02_ProfileSetup_EN`
- `02_ProfileSetup_AR`
- `03_HomeEmpty_EN`
- `03_HomeEmpty_AR`

## Profile Setup

- Header height: 56
- Horizontal screen padding: 24
- Nickname field height: 56
- Role card size: 176 × 108
- Role grid gap: 12
- Save button height: 56
- Screen scrolls when the keyboard reduces available space

## Roles

| Storage value | English | Arabic |
|---|---|---|
| `grandparent` | Grandparent | جد أو جدة |
| `parent` | Parent | أب أو أم |
| `teen` | Teen | مراهق أو مراهقة |
| `child` | Child | طفل أو طفلة |

## Home Empty State

- Header height: 56
- Profile summary minimum height: 88
- Empty-weave card minimum height: 270
- Action-button height: 56
- All repeated spacing uses existing Day 2 tokens

## RTL Rules

- Back arrow reverses direction
- Language action appears at the directional end
- Role-card order remains semantically logical
- Text aligns to the active locale direction
- Icons that are not directional are not mirrored
