# CLAUDE.md — „Die endlosen Lande" (Godot)

Godot-Neubau von Lucas Web-RPG ([genben-sb3/Luca](https://github.com/genben-sb3/Luca), dort eingefroren).
Geschrieben für Ben (12, Projektleiter & Tester) & Luca (13, Spiel-Designer — es ist *sein* Spiel).
Auf Deutsch antworten, freundlich erklären, beide direkt ansprechen. Code **einfach & kommentiert**.

## Eckdaten
- **Godot 4.7.2**, **GDScript**, **2D Top-Down**. Auf Bens Linux-Rechner: `godot` (liegt in `~/.local/opt/godot-4.7.2`).
- **Look:** bunt, cartoonig, Cute-Fantasy — **keine Pixelgrafik**. Alles **in Godot gezeichnet**
  (glatte Formen, weiche Schatten, Shader). Jedes Objekt ist eine eigene Szene, damit man später
  gemalte Bilder einsetzen kann, ohne den Code zu ändern.
- **Begriffe:** siehe [`GLOSSARY.md`](GLOSSARY.md) — im Code & in Texten genau diese Wörter benutzen.
- **Spiel-Daten** (Waffen, Gegner, Wächter, Beute-Tabellen, Preise) zentral halten, nicht im Code verstreut.

## Spiel starten
- Im Repo-Ordner: `godot` → öffnet das Spiel direkt. `godot -e` öffnet stattdessen den Editor.
- Steuerung: WASD oder Pfeiltasten.
- Nach dem ersten Klonen (oder neuen Dateien wie `.po`) einmal importieren: `godot --headless --import`

## Screenshots (Bens Rechner ist ein Server ohne Bildschirm)
- `tools/screenshots.sh` → Bilder in `build/screenshots/`. Das Skript startet bei Bedarf einen
  virtuellen Bildschirm (Xvfb, ohne root in `~/.local/opt/xvfb` installiert, Display `:42`).
- Was dabei passiert (wie lange welche Taste gedrückt wird), steht in `tools/screenshot.gd`.
- Nach jedem Ticket, das man sehen kann: Screenshots machen und Ben/Luca zeigen.

## Web-Version
- `tools/export_web.sh` → baut nach `build/web/` (Vorlagen in `~/.local/share/godot/export_templates/4.7.2.stable/`, nur die Web-Vorlagen sind installiert).
- Ohne Threads exportiert → läuft in jedem Browser, der Server braucht keine besonderen Header.

## Tests
- **GUT 9.7.1** (Addon in `addons/gut`). Alles testen, was ein Spieler erleben würde — nicht interne Hilfsfunktionen.
- Alle Tests ohne Fenster: `godot --headless -s addons/gut/gut_cmdln.gd -gexit` → Exit-Code 0 = alles grün, sonst ≠ 0.
- Eine Testdatei: `… -gselect=test_player_movement.gd -gexit`
- Tests liegen in `test/`, heißen `test_*.gd` (Einstellungen in `.gutconfig.json`).
- `test/test_scripts_load.gd` lädt jedes Skript — so fällt auch eine Testdatei mit Tippfehler auf (GUT würde sie sonst still überspringen).

## Texte
- Jeder Spieltext läuft über `tr("SCHLÜSSEL")`; die deutschen Texte stehen in `locale/de.po`.

## Ablauf
Spec & Tickets liegen als GitHub Issues in diesem Repo (Label `ready-for-agent` = fertig zum Bauen).
