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

The app features a "Liquid Glass" UI aesthetic with animated backgrounds and glassmorphism effects.

## Technology Stack
- **Framework:** Flutter (SDK: ^3.7.2)
- **Language:** Dart
- **Key Dependencies:**
  - `flutter_staggered_grid_view`: ^0.7.0 (For masonry/grid layouts)
  - `url_launcher`: ^6.3.1 (For opening web links)
  - `google_fonts`: ^6.2.1 (For typography)
  - `cupertino_icons`: ^1.0.8 (iOS style icons)
  - `flutter_animate`: ^4.5.0 (For animations)
  - `flutter_lints`: ^5.0.0 (Linting)

## Design System
- **Theme:** Dark mode with animated colorful blobs (Liquid Background).
- **Glassmorphism:** Uses `GlassContainer` with `BackdropFilter` and semi-transparent borders.
- **Animations:** Extensive use of `flutter_animate` for entry and loop animations.

## Code Style & Conventions
- Follow standard Dart analysis options.
- Use `const` constructors wherever possible to improve performance.
- Prefer stateless widgets for UI components that don't require mutable state.
- Ensure all new dependencies are strictly necessary and added to `pubspec.yaml`.

## Architecture
- (To be determined based on `lib/main.dart` analysis - likely a single-page or simple navigation app initially).

## Workflows
- **Running the App:** `flutter run`
- **Testing:** `flutter test`
- **Formatting:** `dart format .`
