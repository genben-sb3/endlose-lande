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

## Tests
- **GUT** (Addon in `addons/gut`). Alles testen, was ein Spieler erleben würde — nicht interne Hilfsfunktionen.
- Ohne Fenster laufen lassen: `godot --headless -s addons/gut/gut_cmdln.gd -gexit`

## Ablauf
Spec & Tickets liegen als GitHub Issues in diesem Repo (Label `ready-for-agent` = fertig zum Bauen).
