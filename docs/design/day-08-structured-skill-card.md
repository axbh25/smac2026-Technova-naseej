# Naseej Day 8 Structured Skill Card

## Reference Device

- Pixel 7 Pro
- Android API 36
- 412 × 892 logical pixels
- Portrait orientation

## Approved Frames

- `16_SkillCardConsent_EN`
- `17_SkillCardGenerating_EN`
- `18_SkillCardAiPreview_EN`
- `19_SkillCardOfflinePreview_EN`
- `20_HomeCardReady_EN`
- `16_SkillCardConsent_AR`
- `17_SkillCardGenerating_AR`
- `18_SkillCardAiPreview_AR`
- `19_SkillCardOfflinePreview_AR`
- `20_HomeCardReady_AR`

## Structured Output

The card contains:

1. One title
2. Exactly three steps
3. One safety note
4. One teach-back question
5. One reciprocal skill suggestion

## Explicit Action

AI generation begins only after the user taps `Generate with AI`.

## Data Sent

- Reviewed explanation
- Teacher role
- Learner role
- Skill category
- Selected output language

## Data Not Sent

- Stored teacher nickname
- Stored learner nickname
- Context photo
- Photo path
- Location
- Contacts

A name typed manually inside the reviewed explanation is part of that
explanation and will be sent unless the user removes it before generation.

## Origins

- AI-generated draft
- Offline Guide

The origin is always visible.

## Offline Behavior

When cloud generation fails, Naseej creates a deterministic local guide.
The Offline Guide is not described as AI-generated.

## Save Behavior

A preview is not saved automatically. The teacher reviews the content and taps
Save 3-Step Card.