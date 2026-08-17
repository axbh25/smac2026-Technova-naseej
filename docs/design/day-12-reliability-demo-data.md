# Naseej Day 12 Reliability and Demo Data

## Reference Device

- Pixel 7 Pro
- Android API 36
- 412 × 892 logical pixels
- Portrait orientation

## Approved English Frames

- `36_LocalDataEmpty_EN`
- `37_LocalDataAiReady_EN`
- `38_LocalDataCompleted_EN`
- `39_LocalDataRecovery_EN`
- `40_LocalDataReset_EN`

## Approved Arabic Frames

- `36_LocalDataEmpty_AR`
- `37_LocalDataAiReady_AR`
- `38_LocalDataCompleted_AR`
- `39_LocalDataRecovery_AR`
- `40_LocalDataReset_AR`

## Recovery Rules

1. Preserve a valid profile when later data is invalid.
2. Preserve a valid draft when the card is invalid.
3. Preserve a valid card when progress is invalid.
4. Clear only the invalid layer and its dependent layers.
5. Display a visible recovery notice.
6. Distinguish repaired data from storage-service failure.
7. Attempt rollback when a multi-layer write fails.

## Demo Rules

1. The AI-ready sample contains a profile and draft only.
2. The AI-ready sample contains no generated card.
3. The completed local sample uses an Offline Guide.
4. The completed local sample is never labeled as live AI.
5. Loading sample data requires confirmation when data already exists.
6. Resetting local data requires confirmation.
7. Current context photos are deleted when possible.
8. The selected interface language is preserved after reset.

## Data Boundary

The Data & Demo screen makes no Firebase or Gemini request.

All sample data is deterministic local Dart data.