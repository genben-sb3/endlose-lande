# Stil-Vorbilder & glatte Kanten in Godot

Recherche vom 23.10.2026 für „Die endlosen Lande“ (Godot 4.7.2, Compatibility-Renderer, Web-Export).
Ausgangspunkt ist Bens Referenzbild: eine Camp-Szene mit Wasserzeichen „yeri.ai“. Wahrscheinlich ist
es KI-generiert, das konnte ich aber nicht prüfen. Es zeigt dicke dunkle Konturen, satte flache Farben
mit weichen Glanzflecken, runde klobige Formen und ein Gras-Plateau mit Erd-Klippen über dem Wasser,
alles in der 3/4-Draufsicht.

> Hinweis: Alle Bilder und Spiele hier sind **zum Anschauen und Lernen** da. Die Grafiken aus den Spielen
> dürfen wir nicht übernehmen. Asset-Packs dürfen wir nur so benutzen, wie es ihre Lizenz erlaubt.

---

## Teil A – Ähnliche Spiele, Asset-Packs und wie man den Stil nennt

### A1. Wie heißt der Stil?

Es gibt **keinen einzelnen Fachbegriff**. Diese Wörter benutzen die Quellen selbst:

| Begriff | Wo er benutzt wird |
|---|---|
| **Cartoon / Cartoony** | Steam-Tags bei Kingdom Rush, Legends of Kingdom Rush, Ittle Dew und Swords of Ditto (Links unten); itch.io-Tag „Cartoon“ bei CraftPix „Simple Summer“ und RhosGFX |
| **Hand-drawn** | Steam-Tags bei Swords of Ditto, Nobody Saves the World und [Bear and Breakfast](https://store.steampowered.com/app/1136370/); itch.io-Tag bei GDS „Top down forest“ |
| **Vector** | CraftPix-Produktnamen („Top-Down Vector Tileset“); GDS: „All assets are 100% vector“ ([Seite](https://gamedeveloperstudio.itch.io/top-down-environmental-asset-pack)) |
| **Cute / Colorful** | Steam-Tags bei fast allen Spielen unten |
| **Cozy / cosy** | Steam-Tag bei [Cozy Grove](https://store.steampowered.com/app/1458100/) und Cat Quest; GDS: „Readable silhouettes ideal for cosy, stylised games“ ([Seite](https://gamedeveloperstudio.itch.io/top-down-containers-barrels-crates-palettes-and-pots)) |
| **stroke weight** (Konturstärke) | GDS: „consistent stroke weight and a unified art style“ (gleiche Seite) |
| **Cartoonish** | [PixelMo „Infinity Forest ‚Cartoonish‘“](https://pixelmo.itch.io/infinity-forest-cartoonish) |
| **Chibi** | heißt: Figuren mit großem Kopf, z. B. „2D Character – Cute & Chibi“ auf der [itch.io-Tag-Seite Cartoon+Top-Down](https://itch.io/game-assets/tag-cartoon/tag-top-down). Das betrifft nur Figuren, nicht die Umgebung. |
| **three quarter view (Zelda link to the past)** | GDS-Forest-Pack ([Seite](https://gamedeveloperstudio.itch.io/top-down-forest-creation-game-asset-pack)), damit ist die Perspektive gemeint |

**Mein Vorschlag:** Den Stil nennen wir unter uns **„Cartoon-Vektor mit dicken Konturen“**. Auf Englisch
sucht man am besten mit *cartoon top-down vector tileset*, *hand-drawn top-down*, *cute cartoon RPG
assets* oder *bold outline*.

### A2. Vorbilder: Spiele (alle auf Steam, offizielle Store-Seiten)

| # | Titel | Link | Warum es passt |
|---|---|---|---|
| 1 | **Ittle Dew 2+** (Ludosity, 2016) | https://store.steampowered.com/app/395620/ | Top-Down-Action-Abenteuer wie unseres: fast schwarze dicke Konturen, runde Puff-Bäume, klobige Baumstümpfe und Steine, 3/4-Sicht |
| 2 | **Ittle Dew** (Ludosity, 2013) | https://store.steampowered.com/app/241320/ | Büsche und Bäume aus überlappenden Kreisen mit kleinen Blüten-Punkten, dicke Konturen. Tags: Cute, Cartoony, Top-Down |
| 3 | **The Swords of Ditto: Mormo's Curse** (onebitbeyond, 2018) | https://store.steampowered.com/app/619780/ | Top-Down-Action-RPG, handgezeichnete dunkle Konturen, Wasser und Klippen. Mehr Details als Bens Bild. Tags: Hand-drawn, Cartoon, Top-Down |
| 4 | **Legends of Kingdom Rush** (Ironhide, 2022) | https://store.steampowered.com/app/1904860/ | Gleiche Requisiten-Sprache: Planwagen, Kisten, Fluss, dicke Formen, dunkle Konturen. Tags: Cute, Cartoony, Colorful |
| 5 | **Kingdom Rush – Tower Defense** (Ironhide, 2014) | https://store.steampowered.com/app/246420/ | Gras-Plateaus mit Klippen-Kanten, Puff-Bäume, satte Farben. Tags: Cartoon, Cartoony, Colorful |
| 6 | **Nobody Saves the World** (DrinkBox, 2022) | https://store.steampowered.com/app/1432050/ | Inseln als Plateaus mit Klippen-Wänden im Wasser, kräftige Konturen. Tags: Hand-drawn, Colorful, Action RPG |
| 7 | **Crashlands** (Butterscotch Shenanigans, 2016) | https://store.steampowered.com/app/391730/ | Crafting-Action-RPG von oben, sehr dicke dunkle Konturen und Blob-Formen. Die Farben sind aber dunkler, das Thema ist Sci-Fi |
| 8 | **Cat Quest** (The Gentlebros, 2017) | https://store.steampowered.com/app/593280/ | Gleiches Genre (Action-RPG, „Cute“, „Cozy“). Auf den Screenshots sehe ich aber **wenig dicke Konturen**, das ist mein Eindruck. Gut als Gegenbeispiel: So wirkt der Stil ohne Konturen |

### A3. Vorbilder: Asset-Packs (Lizenz wörtlich von der jeweiligen Seite)

| # | Pack | Link | Preis & Lizenz (laut Seite) | Warum es passt |
|---|---|---|---|---|
| 9 | **CraftPix – Free Simple Summer Top-Down Vector Tileset** | https://craftpix.net/freebies/free-simple-summer-top-down-vector-tileset/ | kostenlos. „Download this item grants you royalty free usage in unlimited projects.“ Laut [Freebie-Lizenz](https://craftpix.net/file-licenses/) ist kommerzielle Nutzung erlaubt und kein Credit nötig, aber: „You can NOT resell the art source files“ | **Bester Pack-Treffer**: Zelte, Lagerfeuer, Banner, Karren, Kisten, Puff-Bäume, dunkle Konturen. Formate AI/EPS/PNG. Auch auf [itch.io](https://free-game-assets.itch.io/free-summer-fantasy-top-down-vector-tileset) mit dem Tag „Cartoon“ |
| 10 | **CraftPix – Tower Defense Game Tilesets** | https://craftpix.net/product/tower-defense-game-tilesets/ | 5,50 $. „Buy this item grants you royalty free usage in unlimited projects.“ Laut [Lizenz Abschnitt 1](https://craftpix.net/file-licenses/): „Distribution of source files is NOT permitted“ | Fluss mit Uferkante, Puff-Bäume mit Glanz-Fleck oben, Konturen (Kingdom-Rush-artig) |
| 11 | **GDS (Robert Brooks) – Top down forest creation game asset pack** | https://gamedeveloperstudio.itch.io/top-down-forest-creation-game-asset-pack | ab 13 $. Auf der itch-Seite steht **keine Lizenz**. Auf der [GDS-Lizenzseite](https://www.gamedeveloperstudio.com/license.php) steht: „Attribution is not required“, „You may NOT redistribute, share or make available for download any asset“. *Ob die auch für den itch-Kauf gilt, habe ich nicht geprüft.* | Sehr dicke, fast schwarze Konturen, knallige Puff-Bäume, SVG-Quellen, „Zelda link to the past“-Perspektive |
| 12 | **GDS – Top down containers barrels crates palettes and pots** | https://gamedeveloperstudio.itch.io/top-down-containers-barrels-crates-palettes-and-pots | ab 6 $, Lizenz wie bei Nr. 11 | Kisten mit Metallecken und Fässer, „consistent stroke weight“ |
| 13 | **RhosGFX – [DEMO] Vector RPG Overworld Tileset** | https://rhosgfx.itch.io/vector-rpg-overworld-demo | kostenlos. „offered for free under Creative Commons CC0. Credits are appreciated but not required“ | Süßer Vektor-Overworld-Look, einzige **CC0**-Quelle hier. Tags: Cartoon, Colorful, Cute, Vector |
| 14 | **Boogie – Doodle RPG Asset Pack** | https://boogiebalrog.itch.io/doodle-rpg-asset-pack | Preis frei wählbar. Lizenz laut Seite: „YOU CAN: Use these assets for any commercial or non-commercial project; Edit them … YOU CANNOT: Resell these assets, even if edited; Claim the assets are made by you“ | Handgezeichnete dicke Konturen, Zelda-artig, Ritter, Fässer, Büsche. Etwas krakeliger als Bens Bild |
| 15 | **Pixel Frog – Tiny Swords** | https://pixelfrog-assets.itch.io/tiny-swords | Free Pack kostenlos. „Feel free to use this asset pack in both personal and commercial projects … Crediting is not required … You may not redistribute, resell, or repackage the assets“ | **Achtung, das ist Pixel-Art** (Tag „Pixel Art“), also nicht unser Stil. Der Aufbau der Welt ist aber fast gleich: Gras-Plateaus mit Klippen im Wasser, Schaum an der Kante |

Was ich geprüft und nicht aufgenommen habe:
- **Kenney.nl:** Die Suche nach „toon“ auf kenney.nl fand nichts. Einen Kenney-Pack mit dicken Cartoon-Konturen habe ich nicht gefunden.
- **OpenGameArt:** kein klarer Treffer mit CC0 + Vektor + dicker Kontur.
- **GameDev Market und Unity Asset Store:** Die Suche fand dort vor allem Pixel-Art. Diese Packs habe ich nicht genauer angesehen.
- **„Medieval Town & Fantasy 2D Mega Pack“ (nacl1234):** passt optisch, aber auf der Seite fehlt der Hinweis „No generative AI was used“, den alle anderen itch-Packs hier haben. Deshalb habe ich ihn weggelassen.

### A4. Vorschaubilder für Ben

Ordner: `/tmp/claude-1000/-home-ben-ogben/f51cd040-394d-4e2c-af4e-0af231ee4c2b/scratchpad/vorbilder/` (nicht im Repo).

| Datei | Quelle (Bild-URL) | Seite |
|---|---|---|
| `01_simple_summer.webp` | https://img.craftpix.net/2025/09/Free-Simple-Summer-Top-Down-Vector-Tileset3-720x480.webp | Nr. 9 |
| `02_ittle_dew_2.jpg` | https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/395620/ss_3c74c1ccd16e822e759aad6f3ca497aeaa6eeb00.600x338.jpg | Nr. 1 |
| `03_ittle_dew.jpg` | https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/241320/ss_8276fd1d4ac916af3a30f237f581a3c63d88f20c.600x338.jpg | Nr. 2 |
| `04_legends_of_kingdom_rush.jpg` | https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/1904860/ss_281150d5a3d7424e9403151e12b45a008ffe96de.600x338.jpg | Nr. 4 |
| `05_nobody_saves_the_world.jpg` | https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/1432050/ss_7b08dee57dfcf4507bb86823d813154fde26b17c.600x338.jpg | Nr. 6 |
| `06_swords_of_ditto.jpg` | https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/619780/ss_83bd74eee6a7dc91eba5d2e325c96c451a8491da.600x338.jpg | Nr. 3 |
| `07_gds_tree_forest.png` | https://img.itch.zone/aW1hZ2UvMjk2MDkxNy8xNzcxMzMyMi5wbmc=/347x500/707sS0.png | Nr. 11 |
| `08_craftpix_tower_defense.jpg` | https://img.craftpix.net/2017/12/Tower-Defense-Game-Tilesets-1-720x480.jpg | Nr. 10 |

(Steam-Bilder sind die Screenshot-Vorschauen der Store-Seiten, ermittelt über `store.steampowered.com/api/appdetails`.)

### A5. „Was macht diesen Stil aus?“ – Checkliste zum Nachbauen in Code

**Wie gemessen:** Die Farbwerte habe ich aus Bens Bild (1024×1024) per Pixel-Stichprobe und
Farbreduktion abgelesen. Das sind **gerundete Richtwerte**, nicht die Werte der Künstler. Bei den
Vorbildern habe ich nur kleine JPEG-Vorschauen gemessen, dort sind die Werte noch ungenauer.

1. **Kontur (Outline)**
   - **Dicke:** In Bens Bild ist die Außenkontur **5–7 px** dick, bei *jedem* Objekt etwa gleich. Darum
     wirkt sie bei kleinen Dingen relativ dicker: beim Pilz (~45 px) etwa 13 %, bei der Kiste (~160 px)
     etwa 3,5 %, bei der Baumkrone (~250 px) etwa 2,5 %. **Regel für uns:** eine feste Konturbreite für
     die ganze Szene, etwa 3 px bei 1280×720 (ungefähr 2,5–3 % eines mittelgroßen Objekts). Klein gilt
     nicht: kleine Objekte bekommen keine dünnere Kontur.
   - **Innenlinien** (Brettfugen, Risse, Holzmaserung) sind ungefähr **halb so dick**, also ~3 px im Bild.
   - **Farbe:** **nicht reines Schwarz**, sondern ein sehr dunkles warmes Braun-Schwarz, leicht in der Farbe
     des Objekts getönt. Gemessen (dunkelste Pixel): Kiste `#0d0a01`, Stumpf `#100b00`,
     Baum `#111f0d` (grünlich), Banner `#140608` (rötlich-lila), Stein `#1b170c`, Klippe `#2c2717`
     (heller). Als Standard eignet sich `#1f180b`. Zum Tönen nimmt man die Grundfarbe und dunkelt sie auf
     etwa 10–20 % Helligkeit ab.
   - Im Vergleich: Ittle Dew ist fast schwarz (~`#020301`), GDS grün-schwarz (~`#071103`), Legends of
     Kingdom Rush oliv-braun (~`#26230f`), CraftPix „Simple Summer“ weicher oliv (~`#3a481a`).
   - **Wasserkante:** Zwischen Klippe und Wasser gibt es *keine* schwarze Linie. Die dunkelsten Pixel
     dort sind nur ~`#50453e`, dazu kommt ein heller Schaum- oder Glanzstreifen.

2. **Schattierung:** pro Material **3 Töne plus Kontur**, mit harten Kanten (Cel-Look).
   - Grundton, Schatten (dunkler und etwas satter) und Glanz (heller und wärmer/gelblicher).
   - Ein 4. sehr dunkler Ton nur für Löcher, z. B. den Zelteingang (`#645839`).
   - Verläufe (`draw_polygon` mit Farbe pro Ecke) nur ganz sanft einsetzen. Das Bild ist fast flach.

3. **Glanzlichter:** Licht von oben, eher von oben-links (geschätzt).
   - Baumkronen: runde, weiche Glanz-Blobs oben auf jeder „Puff-Kugel“ und kleine „w“/„u“-Bögen
     in einem *dunkleren* Grün (nicht in der Konturfarbe).
   - Steine: hellere Oberseite.
   - Baumstämme: helle Schnittflächen (`#fccb9b`).
   - Schatten unten/unten-rechts, dazu ein dunklerer Gras-Fleck unter jedem Objekt.

4. **Palette** (geschätzt aus Bens Bild):

   | Material | Glanz | Grund | Schatten | dunkel |
   |---|---|---|---|---|
   | Gras | `#c7da7d` | `#b0d57e` | `#8fb967` | `#76a567` |
   | Baum hell | `#c7da7d` | `#b2cd70` | `#82a46c` | – |
   | Baum dunkel | `#8ec7a8`? | `#70af6b` | `#458457` | `#335c3b` |
   | Erd-Klippe | `#e0a67f` | `#d79f7c` | `#c18e73` / `#b1755e` | `#844536` |
   | Wasser | `#cbeaf9` | `#82c3ea` | `#75b0d9` | – |
   | Holz | `#d38754` | `#ad664b` | `#86513d` | `#432617` |
   | Zeltstoff | `#fbdbb0` | `#f1ddb1` | `#cdba7e` | `#645839` |
   | Stein | `#beb6bd` | `#898a8b` | `#574f41` | – |
   | Metall | `#c4c4d2` | `#9292a4` | – | – |
   | Pilz | `#fdf3f2` (Punkte) | `#f11d30` | `#b6323a` | `#440f0d` |
   | Banner | `#f2d6f4` | `#a65be0` | `#6e3b8c` | – |

   Bens Bild ist **heller und pastelliger** als die Vorbilder. Ittle Dew hat Grüns um
   `#32642f`/`#529c36`, GDS knallige `#90db02`/`#3fa80e`, CraftPix `#6fa843`/`#51914d`. Wenn uns
   unsere Szene zu blass vorkommt, nehmen wir die Sättigung etwas hoch und lassen die Helligkeit gleich.

5. **Formen**
   - Alles ist rund, klobig und leicht unregelmäßig, nichts ist perfekt geometrisch.
   - Baumkronen sind aus 3–6 überlappenden Kreisen gebaut.
   - Kisten sind abgerundete Rechtecke mit Metallecken, Stämme dicke Zylinder.
   - Wenige Details: pro Fläche 2–3 Striche, z. B. eine Maserung oder ein Riss.
   - **Grasrand:** Die Grasdecke hängt als **Bogen- oder Wellenkante** über die Klippe, dazu kleine
     Grasbüschel, die herunterhängen.
   - **Klippenwand:** senkrechte Erd-Blöcke mit hellen senkrechten Streifen und dunklen Rissen.

6. **Perspektive:** **3/4-Draufsicht** (GDS nennt das „top down three quarter view (Zelda link to the
   past)“).
   - Den Boden sieht man von oben. Bei Objekten sieht man Oberseite *und* Vorderseite.
   - Klippen zeigen ihre senkrechte Vorderwand.
   - Objekte werden nach y sortiert gezeichnet.

---

## Teil B – Glatte (antialiased) Polygon-Kanten im Compatibility-Renderer

Kurz gesagt: Für `draw_polygon` und `draw_colored_polygon` gibt es in 4.x **kein** Antialiasing, und im
Compatibility-Renderer gibt es **weder 2D-MSAA noch FXAA/SMAA**. Am besten passt zu unserem Stil:
**Füllung zeichnen, dann eine antialiased Kontur mit `draw_polyline(…, true)` darüberlegen.** Die dicke
Kontur gehört sowieso zum Stil, und ihre weichen Ränder überdecken die Treppenstufen der Füllung.

### B1. Welche Zeichenfunktionen haben `antialiased`?

- **Mit `antialiased`** (CanvasItem 4.7):
  - `draw_line`, `draw_dashed_line`, `draw_polyline`, `draw_polyline_colors`, `draw_multiline`,
    `draw_multiline_colors`, `draw_arc`, `draw_ellipse_arc`
  - `draw_rect`, `draw_circle`, `draw_ellipse`, jeweils auch *gefüllt*
  - Quelle: [CanvasItem 4.7](https://docs.godotengine.org/en/4.7/classes/class_canvasitem.html#class-canvasitem-method-draw-polyline)
  - `draw_circle` und `draw_rect` haben den Parameter seit **4.3**: In der
    [4.2-Doku](https://docs.godotengine.org/en/4.2/classes/class_canvasitem.html) fehlt er, in der
    [4.3-Doku](https://docs.godotengine.org/en/4.3/classes/class_canvasitem.html) ist er da.
    `draw_ellipse` gibt es ab **4.6**.
- **Ohne `antialiased`:**
  - `draw_polygon(points, colors, uvs, texture)`, `draw_colored_polygon(points, color, uvs, texture)`,
    `draw_primitive`, `draw_mesh` ([gleiche Seite](https://docs.godotengine.org/en/4.7/classes/class_canvasitem.html#class-canvasitem-method-draw-polygon))
  - Auch `RenderingServer.canvas_item_add_polygon` hat keinen ([Doku](https://docs.godotengine.org/en/4.7/classes/class_renderingserver.html#class-renderingserver-method-canvas-item-add-polygon)).
  - In Godot **3.x** hatten `draw_polygon` und `draw_colored_polygon` noch `antialiased=false`
    ([3.6-Doku](https://docs.godotengine.org/en/3.6/classes/class_canvasitem.html#class-canvasitem-method-draw-polygon)).
- **So funktioniert es (Feathering):** Laut Doku werden „half transparent ‚feathers‘ … attached to
  the boundary“ ([draw_circle](https://docs.godotengine.org/en/4.7/classes/class_canvasitem.html#class-canvasitem-method-draw-circle)).
  Im Quelltext von 4.7.2 sieht das so aus:
  - `FEATHER_SIZE = 1.25f`, siehe [renderer_canvas_cull.cpp L42–46](https://github.com/godotengine/godot/blob/4.7.2-stable/servers/rendering/renderer_canvas_cull.cpp#L42-L46).
  - Eine AA-Polyline wird als **3 Polygon-Befehle** gebaut: der Hauptstreifen plus je ein Feder-Streifen
    links und rechts, deren Alpha nach außen auf 0 geht ([L980–1110](https://github.com/godotengine/godot/blob/4.7.2-stable/servers/rendering/renderer_canvas_cull.cpp#L980-L1110)).
  - Gefüllte AA-Kreise und -Ellipsen sind 1 Polygon plus 1 Feder-Ring ([L1467–1565](https://github.com/godotengine/godot/blob/4.7.2-stable/servers/rendering/renderer_canvas_cull.cpp#L1467-L1565)).
  - Die Linienbreite wird etwas verkleinert, damit die Federn sie wieder ausgleichen. Bei `width ≤ 2.5`
    wird sie halbiert, zwischen 2,5 und 5 gibt es einen Übergang, ab 5 werden 0,625 abgezogen ([L731–745](https://github.com/godotengine/godot/blob/4.7.2-stable/servers/rendering/renderer_canvas_cull.cpp#L731-L745)).
  - Bei `width < 0` gibt es **kein** AA, nur eine Warnung im Log.
  - Ist der **erste Punkt gleich dem letzten**, wird die Polyline als geschlossene Schleife behandelt
    (`loop = p_points[0].is_equal_approx(p_points[point_count - 1])`).
  - *Aus dem Quelltext abgeleitet, nicht getestet:* Die Federn entstehen im lokalen Koordinatensystem.
    Wird die Szene skaliert (Camera2D-Zoom, Node-Scale, `stretch/mode="canvas_items"` bei einem größeren
    Fenster), wird die Feder mit skaliert. Bei 2× Zoom wird sie also weicher (≈2,5 px), bei 0,5× härter.
- **`Line2D.antialiased`** funktioniert. Die Doku warnt aber: „Line2D is not accelerated by batching when
  being anti-aliased“ ([Line2D](https://docs.godotengine.org/en/4.7/classes/class_line2d.html#class-line2d-property-antialiased)).
- **`Polygon2D.antialiased` wirkt in 4.7.2 nicht**, und zwar in keinem Renderer.
  - Die Doku sagt zwar „If true, polygon edges will be anti-aliased“ ([Polygon2D](https://docs.godotengine.org/en/4.7/classes/class_polygon2d.html#class-polygon2d-property-antialiased)).
  - Im Quelltext wird der Wert aber nur gespeichert, mit Setter und Getter ([polygon_2d.cpp L539–546](https://github.com/godotengine/godot/blob/4.7.2-stable/scene/2d/polygon_2d.cpp#L539-L546)).
    Gezeichnet wird per `canvas_item_add_mesh` ganz ohne AA ([L435](https://github.com/godotengine/godot/blob/4.7.2-stable/scene/2d/polygon_2d.cpp#L435)).
  - Die [2D-AA-Anleitung](https://docs.godotengine.org/en/4.7/tutorials/2d/2d_antialiasing.html) sagt das
    auch: „Polygon2D, TextureProgressBar, and several custom drawing methods don't feature an antialiased property.“

### B2. Gibt es Bildschirm-AA für 2D in Compatibility?

- **2D-MSAA: nein.**
  - [ProjectSettings `msaa_2d`](https://docs.godotengine.org/en/4.7/classes/class_projectsettings.html#class-projectsettings-property-rendering-anti-aliasing-quality-msaa-2d):
    „MSAA is only supported in the Forward+ and Mobile rendering methods, not Compatibility.“
  - Das gilt auch für [`Viewport.msaa_2d`](https://docs.godotengine.org/en/4.7/classes/class_viewport.html#class-viewport-property-msaa-2d).
  - Im Quelltext schreibt `render_target_set_msaa` nur `WARN_PRINT("2D MSAA is not yet supported for GLES3.")`
    ([texture_storage.cpp L3202–3217](https://github.com/godotengine/godot/blob/4.7.2-stable/drivers/gles3/storage/texture_storage.cpp#L3202-L3217)).
    Daher kommt eure Meldung.
  - GLES3 kann seit 4.3 MSAA, aber **nur für 3D** ([PR #83976](https://github.com/godotengine/godot/pull/83976), „Add 3D MSAA and scaling support to GLES3“).
- **FXAA/SMAA (`screen_space_aa`): nein.**
  - [ProjectSettings `screen_space_aa`](https://docs.godotengine.org/en/4.7/classes/class_projectsettings.html#class-projectsettings-property-rendering-anti-aliasing-quality-screen-space-aa):
    „only supported in the Forward+ and Mobile rendering methods, not Compatibility.“
  - Im GLES3-Treiber ist die Zeile auskommentiert: `//screen_space_aa = p_config->get_screen_space_aa();`
    ([render_scene_buffers_gles3.cpp L138](https://github.com/godotengine/godot/blob/4.7.2-stable/drivers/gles3/storage/render_scene_buffers_gles3.cpp#L138)).
  - Die [3D-AA-Tabelle](https://docs.godotengine.org/en/4.7/tutorials/3d/3d_antialiasing.html) zeigt für
    Compatibility nur MSAA und SSAA, beide für **3D**. SSAA läuft dort über `rendering/scaling_3d/scale`,
    und das skaliert nur den **3D**-Puffer ([ProjectSettings](https://docs.godotengine.org/en/4.7/classes/class_projectsettings.html#class-projectsettings-property-rendering-scaling-3d-scale)).
  - *Nicht geprüft:* ob FXAA in Forward+ überhaupt 2D-Inhalte glättet. Für uns spielt das keine Rolle.
- **Renderer wechseln geht nicht:** „Godot 4 can only target WebGL 2.0 (using the Compatibility rendering
  method)“ ([Exporting for the Web](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_web.html)).

### B3. Was wirklich hilft

**Wichtig für die Leistung im Compatibility-Renderer:**
- Jeder Polygon-Befehl ist ein **eigener Draw Call**. Im GLES3-Canvas-Renderer steht dazu der Kommentar
  „Polygon's can't be batched, so always create a new batch“ ([rasterizer_canvas_gles3.cpp L1091–1095](https://github.com/godotengine/godot/blob/4.7.2-stable/drivers/gles3/rasterizer_canvas_gles3.cpp#L1091-L1095)).
- Damit kostet:
  - eine Füllung: 1 Draw Call
  - eine AA-Kontur: 3 Draw Calls
  - ein gefüllter AA-Kreis: 2 Draw Calls
- Gemessen wird das mit `Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)` ([Performance](https://docs.godotengine.org/en/4.7/classes/class_performance.html)).
- `_draw()` wird nur einmal ausgeführt, danach merkt sich Godot die Befehle, bis jemand `queue_redraw()`
  aufruft ([Custom drawing](https://docs.godotengine.org/en/4.7/tutorials/2d/custom_drawing_in_2d.html)).
  Also **nicht jedes Frame neu zeichnen**.
- Wie viele Draw Calls im Browser zu viel sind, habe ich **nicht gemessen**. Das müssen wir auf Bens
  Rechner ausprobieren.

**Option 1 – Füllung plus AA-Kontur (empfohlen):**
```gdscript
const OUTLINE := Color("1f180b")  # dunkles Braun-Schwarz statt reinem Schwarz

func draw_form(punkte: PackedVector2Array, farbe: Color, breite := 3.0) -> void:
	draw_colored_polygon(punkte, farbe)        # Füllung (Kante allein wäre zackig)
	var ring := punkte.duplicate()
	ring.append(punkte[0])                     # erster == letzter Punkt → geschlossene Schleife
	draw_polyline(ring, OUTLINE, breite, true) # antialiased → weiche Federn verdecken die Stufen
```
Mit `draw_polygon(punkte, farben)` und Farbverlauf funktioniert es genauso.

**Option 2 – Runde Teile als AA-Kreise, Kontur als „Silhouette dahinter“:** Das passt gut für
Baumkronen aus mehreren Kreisen. Zuerst alle Kreise mit `r + breite` in der Konturfarbe zeichnen, danach
alle Kreise mit `r` in Grünfarbe. So entsteht automatisch die Umriss-Kontur der ganzen Krone.
```gdscript
for k in kreise: draw_circle(k.pos, k.r + 3.0, OUTLINE, true, -1.0, true)
for k in kreise: draw_circle(k.pos, k.r, k.farbe, true, -1.0, true)
```
Die „w“-Blattbögen gehen mit `draw_arc(…, breite, true)`.

**Option 3 – Formen ohne Kontur (Glanz-Blobs, Schatten):**
- Über der Füllung eine AA-Polyline **in derselben Farbe** ziehen, Breite ~1–1,5.
- Nach innen fällt die Feder nicht auf, nach außen läuft sie weich aus.
- Bei **halbtransparenten** Farben überlappen sich Füllung und Linie, dann sieht man einen helleren
  oder dunkleren Rand. Das habe ich aus der Bauweise abgeleitet, nicht getestet.

**Option 4 – Eigene Feder in einem Mesh (am schnellsten, mehr Code):**
- Mit [`Geometry2D.offset_polygon`](https://docs.godotengine.org/en/4.7/classes/class_geometry2d.html#class-geometry2d-method-offset-polygon)
  den Umriss um ~1 px vergrößern.
- Zwischen Original-Umriss (Alpha 1) und vergrößertem Umriss (Alpha 0) einen Dreiecks-Ring bauen.
- Füllung und Ring zusammen mit **einem** Aufruf
  [`RenderingServer.canvas_item_add_triangle_array`](https://docs.godotengine.org/en/4.7/classes/class_renderingserver.html#class-renderingserver-method-canvas-item-add-triangle-array)
  zeichnen, oder als `ArrayMesh` mit `draw_mesh`.
- Ergebnis: 1 Draw Call pro Objekt statt ~4 pro Form. Lohnt sich erst, wenn Option 1 messbar zu
  langsam wird.

**Option 5 – Supersampling mit SubViewport (2×):**
- Aufbau: Die Welt liegt in einem `SubViewport` mit doppelter Größe (bei uns 2560×1440) und einer
  `Camera2D` mit `zoom = Vector2(2, 2)`.
- Angezeigt wird das über ein `TextureRect` mit `ViewportTexture`, auf Fenstergröße skaliert, mit
  `texture_filter = LINEAR`. Unser Projekt hat Linear schon als Standard:
  `textures/canvas_textures/default_texture_filter=1`.
- Vorteil: Das glättet **alles**, auch Innenkanten.
- Kosten (geschätzt, nicht gemessen):
  - **4× so viele Pixel** zu füllen
  - ~14 MB zusätzlicher Speicher für das Render-Target (RGBA8)
  - ein extra Durchgang über den ganzen Bildschirm
  - Die Zahl der Draw Calls bleibt gleich.
- Godot nennt Supersampling allgemein „extremely high cost“ und empfiehlt bei Faktor `2.0` ganzzahlig
  zu bleiben, weil die Hardware bilinear herunterrechnet ([3D-AA, Abschnitt SSAA](https://docs.godotengine.org/en/4.7/tutorials/3d/3d_antialiasing.html)).
- Nachteile:
  - Mit `stretch/mode="canvas_items"` und einem Fenster, das nicht 1280×720 ist, wird das Verhältnis
    krumm.
  - Maus-Eingaben kommen über ein `TextureRect` nicht im SubViewport an. Ein `SubViewportContainer`
    leitet Eingaben weiter, zeigt die Textur aber in ihrer echten Größe an.
  - `SubViewport.size_2d_override` / `size_2d_override_stretch` könnten die Kamera-Lösung ersetzen.
    Die Doku sagt dazu nur „If true, the 2D size override affects stretch as well“
    ([SubViewport](https://docs.godotengine.org/en/4.7/classes/class_subviewport.html)). **Nicht getestet.**

**Empfehlung für viele kleine Formen im Web:**
1. Standard ist **Option 1 + 2**: Füllung plus `draw_polyline(…, true)` für Kanten, `draw_circle`/
   `draw_ellipse` mit AA für runde Teile. Das passt zum Stil und braucht keine Extra-Textur. Statische
   Objekte zeichnen wir nur einmal.
2. Draw Calls mit dem Performance-Monitor beobachten. Wird es im Browser zu langsam, bauen wir die
   häufigsten Objekte (Bäume, Gras, Steine) auf **Option 4** um, also ein Mesh pro Objekt.
3. **Option 5** nur als optionale „Hohe Qualität“-Einstellung für starke PCs. Für viele kleine Formen
   auf schwachen Geräten im Browser ist sie die teuerste Lösung.
