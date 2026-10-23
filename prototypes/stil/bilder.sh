#!/usr/bin/env bash
# PROTOTYP – macht je ein Bild von jedem Stil (und eins bei Nacht) nach build/stil/.
set -euo pipefail
cd "$(dirname "$0")/../.."
export DISPLAY=:42
[ -S /tmp/.X11-unix/X42 ] || { nohup "$HOME/.local/opt/xvfb/root/usr/bin/Xvfb" :42 -screen 0 1280x720x24 -nolisten tcp >/dev/null 2>&1 & sleep 2; }
mkdir -p build/stil
for s in 1 2 3; do
	godot --display-driver x11 --rendering-driver opengl3 -s prototypes/stil/aufnahme.gd -- stil=$s "$(realpath build/stil)/stil_$s.png" 2>&1 | grep -E "SCRIPT ERROR" || true
done
godot --display-driver x11 --rendering-driver opengl3 -s prototypes/stil/aufnahme.gd -- stil=1 nacht "$(realpath build/stil)/stil_1_nacht.png" 2>&1 | grep -E "SCRIPT ERROR" || true
ls build/stil
