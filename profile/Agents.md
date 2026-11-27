# Project Context for AI Agents

## Project Overview
This is a Flutter-based application named "profile". The project is a personal portfolio showcasing work experience and projects.
Based on the assets, the portfolio likely includes work history or projects related to:
- Jio
- Zebpay
- Auro
- Ailoitte
- Redweb
- Cakap
- Fullerton
- SOS Method

The app is an immersive 3D portfolio: perspective device scenes, a skill orbit, a scroll-driven career timeline, a project coverflow and an isometric architecture diagram.

## Technology Stack
- **Framework:** Flutter (SDK: ^3.7.2)
- **Language:** Dart
- **Key Dependencies:**
  - `url_launcher`: ^6.3.1 (For opening web links)
  - `google_fonts`: ^8.0.0 (Sora display, Inter body, JetBrains Mono accents)
  - `cupertino_icons`: ^1.0.8 (iOS style icons)
  - `flutter_animate`: ^4.5.0 (For animations)
  - `flutter_lints`: ^5.0.0 (Linting)

## Design System
- **Tokens:** `lib/theme/app_theme.dart` (`AppColors`, `AppText`, `Breakpoints`). Near-black background, cyan primary, violet secondary.
- **Surfaces:** `GlassPanel` (translucent card, hairline border, optional glow). `BackdropFilter` is used only in the nav bar for performance.
- **3D:** `Scene3D` (`lib/core/scene_3d.dart`) places widgets in a shared perspective space with `Matrix4`. Devices are extruded by stacking edge slices.
- **Motion:** `Reveal` (scroll-triggered entry), `ViewportTickerGate` (pauses off-screen tickers), `TiltCard`, `Floating`. Always check `Motion.reduced(context)`.

## Code Style & Conventions
- Follow standard Dart analysis options.
- Use `const` constructors wherever possible to improve performance.
- Prefer stateless widgets for UI components that don't require mutable state.
- Ensure all new dependencies are strictly necessary and added to `pubspec.yaml`.

## Architecture
- Single-page app. `lib/app.dart` hosts a `SingleChildScrollView` of sections plus a floating `NavBar`. `PageScope` shares the scroll controller, the normalised pointer position and the section anchors.
- Content is separated from UI: all copy and data live in `lib/data/portfolio_data.dart`. Never invent career facts; leave optional fields empty instead.
- Sections live in `lib/sections/`, and reusable widgets in `lib/widgets/`.
- Deployment: `./scripts/deploy_web.sh` builds with `--base-href /profile/` and commits to the `gh-pages` branch.

## Workflows
- **Running the App:** `flutter run`
- **Testing:** `flutter test`
- **Formatting:** `dart format .`
