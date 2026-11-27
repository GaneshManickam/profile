# Ganesh Manickam — Portfolio

An immersive, interactive 3D portfolio built entirely with **Flutter Web** and
hosted on **GitHub Pages** at `https://<user>.github.io/profile/`.

## Highlights

- **3D hero scene**: a floating, extruded smartphone whose home screen shows the
  real apps from the portfolio, orbited by Swift / Flutter / iOS / Android
  badges, a code card, an architecture diagram and UI components. It follows the
  mouse on desktop and can be dragged on touch screens.
- **3D developer workspace** (laptop, tablet, phone) in the About section.
- **Skill universe**: an interactive orbit of tilted rings. Tap a badge or chip
  to see what it is and which shipped apps use it. There are no percentage bars.
- **Career timeline**: a glowing rail that fills as you scroll, with expandable
  role cards that show tenure, promotions and related apps.
- **Project coverflow**: every app sits in its own 3D phone with a domain-tinted
  launch screen built from its real icon. Swipe, drag, use the arrows or the
  keyboard (← →).
- **How I Build**: an auto-advancing lifecycle pipeline plus an isometric
  architecture stack with animated data flow.
- **Contact**: a phone with a messaging-style contact screen and real links.

## Tech

Flutter (Dart) with `google_fonts`, `url_launcher` and `flutter_animate`. All 3D
work is done with `Transform` + `Matrix4` perspective and `CustomPainter`, so it
needs no WebGL plugin or extra assets and runs in the default CanvasKit renderer.

## Project structure

```
lib/
  main.dart                 # entry point
  app.dart                  # MaterialApp, page shell, scroll + pointer services
  theme/app_theme.dart      # colours, typography, breakpoints, ThemeData
  data/
    models.dart             # immutable content models
    portfolio_data.dart     # ALL portfolio content (edit this to update the site)
  core/
    motion.dart             # Reveal, ViewportTickerGate, Floating, TiltCard
    scene_3d.dart           # tiny perspective 3D stage used by the device scenes
    page_scope.dart         # shared ScrollController / pointer / section anchors
  widgets/                  # reusable UI: device frames, phone screens, buttons, …
  sections/                 # hero, about, skills, experience, projects, process, contact
```

### Updating content

Everything shown on the site lives in `lib/data/portfolio_data.dart`:

- `profile.resumeUrl`: set it to show the **Download Resume** buttons. For
  example, drop `resume.pdf` into `web/` and set `resumeUrl: 'resume.pdf'`.
- `profile.email`: set it to add a mail CTA and contact row.
- `Experience.highlights`: add responsibilities and achievements per role. The
  expanded card lists them.
- `Project.role` / `Project.screenshots`: optional. Screenshots (asset paths)
  replace the generated launch screen inside the device.

## Accessibility & performance

- Respects **reduced motion** (`prefers-reduced-motion`): looping animations,
  auto-rotation and scroll effects switch off.
- Every interaction works by tap as well as by hover.
- Semantic labels on links, buttons, headings and decorative scenes.
- Looping animations pause automatically when off-screen (`ViewportTickerGate`).
- Images are decoded at display size (`cacheWidth`). Only referenced assets are
  bundled.

## Running locally

```bash
flutter pub get
flutter run -d chrome
```

Tests and analysis:

```bash
flutter analyze && flutter test
```

## Deploying to GitHub Pages

The site is served from the `gh-pages` branch under `/profile/`.

```bash
./scripts/deploy_web.sh
```

```bash
git push origin gh-pages
```

The script runs analysis and tests, then builds with
`flutter build web --release --base-href /profile/`. It copies the output into
the `gh-pages` branch through a temporary worktree and commits it, but doesn't
push.
