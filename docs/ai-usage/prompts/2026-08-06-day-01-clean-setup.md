# Day 1 Prompt — Naseej Setup and Development Plan

For this chat, assume the following:

- The app name is **Naseej** and will remain **Naseej**.
- I am developing the app using **Flutter in VS Code**.
- The **Flutter extension/plugin is already installed in VS Code**.
- **Android Studio is already installed**.
- I have a working **Android virtual emulator** for testing the app.
- The **GitHub repository has already been created** and contains the current Naseej project files.
- I will use **Figma** to design the UI for each screen before implementing it in Flutter.
- My teammate **Shoug and I are beginners**, so we will use AI assistance for some of the coding.
- We want the Flutter implementation to match the Figma designs as closely and accurately as possible.

## Step 1 — Understand the Repository

@GitHub

Please read through the current **Naseej GitHub repository** and understand its structure and contents.

Then:

1. Summarize the repository in simple language.
2. Explain the purpose of the important folders and files.
3. Tell me what has already been completed.
4. Tell me what is still missing or needs to be developed.
5. Point out anything that may cause problems later.

**Do not make, edit, delete, commit, or push any files.**  
For now, GitHub access should be **read-only**.

## Step 2 — Plan Day 1

After reviewing the repository, tell me **exactly what Shoug and I should do on Day 1**.

I want very detailed, beginner-friendly instructions.

Treat us as if we are building our first Flutter application.

For every step:

- Tell us **what we are doing**.
- Explain **why we are doing it**.
- Tell us **where to click** when using VS Code, Android Studio, Figma, GitHub, or another tool.
- Give us the **exact terminal command** when a command is required.
- Tell us **which folder the command should be run from**.
- Tell us **which file to open or create**.
- Explain any code before asking us to use it.
- Tell us exactly **where the code should go**.
- Tell us what result we should expect after completing the step.
- Include a simple way to **verify that the step worked correctly**.
- Warn us before doing anything that could overwrite, delete, or significantly change existing work.

Do not skip steps because they seem obvious.

## Figma → Flutter Workflow

We will design each screen in **Figma first** and then reproduce it in Flutter.

Our goal is for the Flutter application to look as close to the Figma design as possible.

When we begin implementing a Figma screen:

1. Tell us what information you need from the Figma design.
2. Help us identify:
   - screen dimensions
   - spacing
   - padding
   - margins
   - fonts
   - font sizes
   - font weights
   - colors
   - border radii
   - icons
   - images/assets
   - component sizes
   - alignment
3. Show us how those Figma properties translate into Flutter widgets and values.
4. Do not invent design values when the Figma design provides them.
5. If information is missing, tell us exactly what you need before assuming a value.
6. Prefer reusable Flutter widgets/components rather than duplicating UI code.

We want a **pixel-accurate implementation where practical**, while also keeping the Flutter code clean and maintainable.

## Coding Approach

Because we are beginners:

- Keep the architecture simple.
- Do not introduce advanced packages, state-management libraries, or complex architecture unless they are actually needed.
- Explain new Flutter concepts when they first appear.
- Keep files organized from the beginning.
- Use clear variable, class, widget, and file names.
- Avoid unnecessary code.
- Follow good Flutter practices.
- Tell us when we should test the app in the Android emulator.
- Tell us when we should run:

```powershell
flutter analyze
