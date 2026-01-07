# Implementation Plan - Liquid Glass UI

The goal is to overhaul the `profile` app UI to feature an "Apple-style Liquid Glass" aesthetic, replacing the current "Retro Pastel" theme. This involves moving, colorful backgrounds, frosted glass cards (glassmorphism), and sleek entry animations.

## User Review Required
> [!IMPORTANT]
> This implementation will significantly change the visual appearance from a "Retro Pastel" look to a modern "Liquid Glass" look. The underlying content (Skills, Experience, Projects) will be preserved.

## Proposed Changes

### Dependencies
- Add `flutter_animate` to `pubspec.yaml` for declarative, sleek entry and effect animations.

### `lib/main.dart`
- **Theme**: Switch from `retroPastelScheme` to a dark-mode dominant theme with vibrant gradients.
- **Widgets to Implement/Replace**:
  - `LiquidBackground`: A stack of animated, blurred, colored blobs (gradients) that move slowly to create a "fluid" feel behind the glass.
  - `GlassContainer`: A reusable widget encapsulating `BackdropFilter` (blur), semi-transparent white/gray color, and subtle border.
  - `ProfileHeader` / `HeroSection`: Update to use Glass cards.
  - `BentoCard` / `InfoCard`: Update to use `GlassContainer`.
  - `ProjectGrid`: Use staggered grid of glass tiles.

### Data Preservation
- The existing lists for `skills`, `experience` (in `ExperienceSection`), and `projects` (in `ProjectsSection`) will be kept and adapted to the new UI components.

## Verification Plan
### Automated Tests
- Run `flutter test` to ensure no widget build errors.
### Manual Verification
- Verify the "Liquid" background animation is smooth.
- Verify the "Glass" effect (blur) works correctly on top of the background.
- Check accessibility/readability of text on glass.
