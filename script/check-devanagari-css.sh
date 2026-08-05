#!/bin/bash
# Fails if letter-spacing, text-transform: uppercase, or font-stretch: condensed
# appear anywhere in our CSS. These break Devanagari conjuncts or describe a
# concept the script doesn't have — see docs/02-design-system.md. The design
# doesn't call for them on Latin text either, so this is a blanket ban rather
# than trying to scope a check to just Devanagari selectors.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="$ROOT/app/assets/tailwind"

matches=$(grep -RnE 'letter-spacing[[:space:]]*:|text-transform[[:space:]]*:[[:space:]]*uppercase|font-stretch[[:space:]]*:[[:space:]]*condensed' "$TARGET" | grep -vE '^[^:]+:[0-9]+:[[:space:]]*(\*|//)' || true)

if [ -n "$matches" ]; then
  echo "Devanagari guard failed — forbidden property found:"
  echo "$matches"
  exit 1
fi

echo "Devanagari guard: OK (no letter-spacing / uppercase / condensed in app/assets/tailwind)"
