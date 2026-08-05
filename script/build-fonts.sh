#!/bin/bash
# Rebuilds the self-hosted subsetted webfonts in app/assets/fonts/.
#
# Requires: curl, python3 with `fonttools` and `brotli` installed
#   (e.g. `python3 -m venv .fontenv && .fontenv/bin/pip install fonttools brotli`
#   then run this script with that venv activated).
#
# Downloads source TTFs from the google/fonts repo (OFL-licensed), pins the
# two variable fonts (Inter, Source Serif 4) to static weight/optical-size
# instances, then subsets everything to Devanagari + Latin ranges and emits
# woff2. See docs/02-design-system.md for the font/weight decisions.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK="$(mktemp -d)"
DEST="$ROOT/app/assets/fonts"
trap 'rm -rf "$WORK"' EXIT

mkdir -p "$DEST"
cd "$WORK"

echo "== downloading source fonts =="
curl -sL --max-time 30 -o TiroDevanagariMarathi-Regular.ttf "https://raw.githubusercontent.com/google/fonts/main/ofl/tirodevanagarimarathi/TiroDevanagariMarathi-Regular.ttf"
curl -sL --max-time 30 -o Mukta-Regular.ttf "https://raw.githubusercontent.com/google/fonts/main/ofl/mukta/Mukta-Regular.ttf"
curl -sL --max-time 30 -o Mukta-SemiBold.ttf "https://raw.githubusercontent.com/google/fonts/main/ofl/mukta/Mukta-SemiBold.ttf"
curl -sL --max-time 30 -o Mukta-Bold.ttf "https://raw.githubusercontent.com/google/fonts/main/ofl/mukta/Mukta-Bold.ttf"
curl -sL --max-time 30 -o SourceSerif4-Variable.ttf "https://raw.githubusercontent.com/google/fonts/main/ofl/sourceserif4/SourceSerif4%5Bopsz%2Cwght%5D.ttf"
curl -sL --max-time 30 -o Inter-Variable.ttf "https://raw.githubusercontent.com/google/fonts/main/ofl/inter/Inter%5Bopsz%2Cwght%5D.ttf"

# Devanagari: core block + ZWJ/ZWNJ (needed for conjuncts) + Rupee sign.
DEVA="U+0900-097F,U+200C,U+200D,U+20B9"
# Latin: basic Latin + Latin-1 supplement + general punctuation + currency.
LATN="U+0020-007E,U+00A0-00FF,U+2000-206F,U+20AC,U+20B9"

echo "== instancing variable fonts to static weights =="
fonttools varLib.instancer -q -o Inter-Regular-static.ttf   Inter-Variable.ttf wght=400 opsz=14
fonttools varLib.instancer -q -o Inter-SemiBold-static.ttf Inter-Variable.ttf wght=600 opsz=14
fonttools varLib.instancer -q -o Inter-Bold-static.ttf     Inter-Variable.ttf wght=700 opsz=14
# opsz pinned toward the display end (range 8-60, default 20) for the higher-contrast cut that
# suits headline sizes. wght=400 (not bolder) because Tiro Devanagari Marathi only ships a
# Regular cut, and the two headline fonts share one heading style across languages.
fonttools varLib.instancer -q -o SourceSerif4-Display-static.ttf SourceSerif4-Variable.ttf wght=400 opsz=40

echo "== subsetting to woff2 =="
pyftsubset TiroDevanagariMarathi-Regular.ttf \
  --output-file="$DEST/tiro-devanagari-marathi-regular.woff2" \
  --flavor=woff2 --layout-features='*' --unicodes="$DEVA,$LATN"

for w in Regular:400 SemiBold:600 Bold:700; do
  name="${w%%:*}"; weight="${w##*:}"
  pyftsubset "Mukta-$name.ttf" \
    --output-file="$DEST/mukta-$weight.woff2" \
    --flavor=woff2 --layout-features='*' --unicodes="$DEVA,$LATN"
done

pyftsubset SourceSerif4-Display-static.ttf \
  --output-file="$DEST/source-serif-4-display-400.woff2" \
  --flavor=woff2 --layout-features='*' --unicodes="$LATN"

for w in Regular:400 SemiBold:600 Bold:700; do
  name="${w%%:*}"; weight="${w##*:}"
  pyftsubset "Inter-$name-static.ttf" \
    --output-file="$DEST/inter-$weight.woff2" \
    --flavor=woff2 --layout-features='*' --unicodes="$LATN"
done

echo "== done =="
ls -la "$DEST"
