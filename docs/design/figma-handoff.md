# Naseej Figma-to-Flutter Handoff Contract

## Visual Source of Truth

The approved Figma frame is the source of truth for appearance.

Flutter implementation must not guess a value that can be measured in Figma.

## Primary Reference Device

- Hardware: Pixel 7 Pro
- Android: API 36
- Physical profile: 1440 × 3120
- Density: 560 dpi
- Approximate logical viewport: 412 × 892
- Orientation: Portrait

## Figma File

File name: `Naseej — SMAC 2026`

Pages:

1. `00_Cover`
2. `01_Foundations`
3. `02_Components`
4. `03_Screens_EN`
5. `04_Screens_AR`
6. `05_Prototype`
7. `06_Dev_Handoff`
8. `07_QA_Overlays`

## Screen Inventory

1. Welcome
2. Home
3. Teach Skill
4. Review Card
5. Teach-Back
6. Exchange Complete

Every screen requires separate English and Arabic approval.

## Exact-Match Rule

At the 412 × 892 reference viewport:

- One Figma pixel maps to one Flutter logical pixel
- Flutter uses the same font family and font files
- Font sizes, weights, line heights, and letter spacing match
- Padding and gaps match measured Figma values
- Corner radii, borders, colors, icons, and shadows match
- System-safe areas are accounted for
- Every repeated component is reusable

The application must still adapt safely to other phone dimensions.

## Figma-to-Flutter Mapping

| Figma | Flutter |
|---|---|
| Vertical Auto Layout | `Column` |
| Horizontal Auto Layout | `Row` |
| Wrapping Auto Layout | `Wrap` |
| Fill container | `Expanded`, `Flexible`, or constraints |
| Hug contents | Content-sized widget |
| Padding | `EdgeInsetsDirectional` |
| Start/end alignment | `AlignmentDirectional` |
| Component | Reusable widget |
| Variant | Widget state or constructor parameter |
| Variable | Theme/design token |
| Radius | `BorderRadius` |
| Stroke | `Border` |
| Shadow | `BoxShadow` |

## RTL Rules

- Use locale-driven `Directionality`
- Use `start` and `end`, not fixed left and right
- Use `EdgeInsetsDirectional`
- Use `AlignmentDirectional`
- Review Arabic line breaks manually
- Do not mirror ordinary photographs
- Mirror directional arrows only when their meaning changes with direction
- Do not merely reverse an English screenshot

## Asset Rules

- Custom icons: SVG
- Photos and illustrations: WebP or PNG
- Never export text as an image
- Never export a complete screen as one image
- Use lowercase snake_case file names
- Remove unused assets
- Record the export scale

## Screen Approval States

Each frame has one status:

- Draft
- Internal Review
- Ready for Development
- Implemented
- QA Matched

Flutter coding begins only after a frame is marked Ready for Development.

## Visual QA Process

1. Run the app on the Pixel 7 Pro emulator.
2. Capture an emulator screenshot.
3. Import the screenshot into `07_QA_Overlays`.
4. Align it over the approved 412 × 892 Figma frame.
5. Set the screenshot opacity to 50%.
6. Compare spacing, baselines, text wrapping, sizes, colors, and safe areas.
7. Correct the Flutter implementation.
8. Repeat until differences are minimal.
9. Test a smaller phone after matching the reference viewport.
