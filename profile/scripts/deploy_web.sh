#!/usr/bin/env bash
# Builds the portfolio for GitHub Pages and commits it to the gh-pages branch.
#
#   ./scripts/deploy_web.sh          # build + commit to gh-pages (no push)
#   git push origin gh-pages         # publish
#
# The site is served from https://<user>.github.io/profile/, so the base href
# must be /profile/. Override with BASE_HREF=/other/ if the repo is renamed.
set -euo pipefail

BASE_HREF="${BASE_HREF:-/profile/}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORKTREE="$ROOT/build/gh-pages"

cd "$ROOT"
flutter pub get
flutter analyze
flutter test
flutter build web --release --base-href "$BASE_HREF"

# Check out gh-pages in a throwaway worktree so the source branch is untouched.
git fetch origin gh-pages
git worktree remove --force "$WORKTREE" 2>/dev/null || true
git worktree add "$WORKTREE" origin/gh-pages --detach

# Replace the published files, keeping git metadata and the CNAME if present.
find "$WORKTREE" -mindepth 1 -maxdepth 1 ! -name .git ! -name CNAME -exec rm -rf {} +
cp -R build/web/. "$WORKTREE/"
touch "$WORKTREE/.nojekyll"

cd "$WORKTREE"
git add -A
if git diff --cached --quiet; then
  echo "No changes to deploy."
else
  git commit -m "Deploy portfolio $(git -C "$ROOT" rev-parse --short HEAD)"
  git branch -f gh-pages HEAD
  echo
  echo "Committed to local gh-pages. Publish with:  git push origin gh-pages"
fi
cd "$ROOT"
git worktree remove --force "$WORKTREE"
