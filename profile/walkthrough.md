# 3D Portfolio Redesign — Walkthrough

## What changed
- The single 1,400-line `main.dart` became a modular app:
  - `theme/`: design tokens
  - `data/`: models and content
  - `core/`: motion utilities and the `Scene3D` perspective stage
  - `widgets/`: reusable UI
  - `sections/`: one file per section
- New sections and visuals: the 3D phone hero, the 3D workspace in About, the
  skill orbit, the scroll-driven timeline, the project coverflow, the lifecycle
  pipeline with the isometric architecture stack, and the 3D contact phone.
- A branded loading screen in `web/index.html` fades out on Flutter's
  `flutter-first-frame` event.
- Removed the unused `flutter_staggered_grid_view` dependency.
- Assets are listed explicitly so the 870 KB favicon original is no longer
  bundled. `orca_app_icon.png` was downscaled from 512 to 256 px (251 KB → 77 KB).

## Content
All existing content was carried over unchanged: profile, socials, skills, all
7 roles with dates, and all 7 projects with their store links. Additions are
limited to information derived from that content:
- tenure, promotions and company count
- domain labels taken from the project descriptions
- "Architecture" skills taken from the summary (VIPER/MVVM/MVC) and Dart
  (implied by the Flutter app)

Optional fields are left empty until real data is provided: resume, email, per-role
highlights and screenshots.
