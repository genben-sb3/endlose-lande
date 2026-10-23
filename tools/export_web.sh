#!/usr/bin/env bash
# Baut die Web-Version nach build/web/ (braucht die Godot-Export-Vorlagen 4.7.2,
# installiert in ~/.local/share/godot/export_templates/4.7.2.stable/).
# Aufruf:  tools/export_web.sh
set -euo pipefail
cd "$(dirname "$0")/.."

# build/ ist für Godot tabu – sonst landen z. B. Screenshots im Spiel.
mkdir -p build/web
touch build/.gdignore

godot --headless --export-release Web build/web/index.html 2>&1 | grep -iE "error" || true
ls -lh build/web/index.wasm build/web/index.pck
