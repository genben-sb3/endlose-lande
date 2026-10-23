#!/usr/bin/env bash
# Macht Screenshots vom Spiel – auch auf dem Server ohne Bildschirm.
# Aufruf:  tools/screenshots.sh [ausgabe-ordner]     (Standard: build/screenshots)
# Startet dafür bei Bedarf einen virtuellen Bildschirm (Xvfb auf :42).
set -euo pipefail
cd "$(dirname "$0")/.."

OUT="${1:-build/screenshots}"
XVFB="${XVFB:-$HOME/.local/opt/xvfb/root/usr/bin/Xvfb}"
export DISPLAY=:42

# Läuft schon ein virtueller Bildschirm? Sonst einen starten.
if [ ! -S /tmp/.X11-unix/X42 ]; then
	nohup "$XVFB" :42 -screen 0 1280x720x24 -nolisten tcp >/dev/null 2>&1 &
	sleep 2
fi

mkdir -p "$OUT" build
touch build/.gdignore
godot --display-driver x11 --rendering-driver opengl3 -s tools/screenshot.gd -- "$(realpath "$OUT")" 2>&1 | grep gespeichert
