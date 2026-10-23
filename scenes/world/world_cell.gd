# Eine Zelle der Oberwelt (22 × 22 Kacheln): zeichnet Boden, Wasser, Bäume und Felsen
# und baut die Hindernisse, durch die man nicht laufen kann.
# Alles wird nur einmal beim Laden gezeichnet – danach merkt sich Godot das Bild.
# Das hält die Bildrate hoch, auch wenn viele Zellen geladen sind.
#
# Gezeichnet wird in vier Ebenen (Boden, Ufer, Wasser, Dinge). Weiche Formen ragen etwas in die
# Nachbarzelle hinein; durch die Ebenen deckt der Boden der Nachbarzelle sie nicht zu.
extends Node2D

## Grasfarben je Biom (drei Töne, damit der Boden lebendig aussieht). Aus der Web-Version.
const GRAS := {
	WorldGen.Biome.MEADOW: [Color("#9ed27a"), Color("#92cc6c"), Color("#a7d986")],
	WorldGen.Biome.PLAINS: [Color("#86c46a"), Color("#7bbb5e"), Color("#93cc77")],
	WorldGen.Biome.FOREST: [Color("#5fa85f"), Color("#56a056"), Color("#69b269")],
	WorldGen.Biome.ROCKY: [Color("#9fb083"), Color("#94a679"), Color("#a8b88e")],
	WorldGen.Biome.LAKE: [Color("#83c8a0"), Color("#76c096"), Color("#8fd0ab")],
}
## Die Zeichen-Ebenen (z-Index): kleiner = weiter hinten.
const EBENE_BODEN := -4
const EBENE_UFER := -3
const EBENE_WASSER := -2
const EBENE_DINGE := -1

const WASSER := Color("#5bb8e6")
const WASSER_HELL := Color("#8fd3f2")
const UFER := Color("#e9dca8")
const BLUMEN := [Color("#ffffff"), Color("#ffe066"), Color("#ff8fb1"), Color("#b18cff")]
const BLUMEN_MITTE := Color("#ffb703")

## Alle Hindernisse teilen sich dieselben zwei Formen – das spart Speicher.
static var _wasser_form := RectangleShape2D.new()
static var _rund_form := CircleShape2D.new()

var cell: Vector2i
var _gen: WorldGen
## Kachel-Art und Biom jeder Kachel, einmal beim Laden ausgerechnet (Rauschen ist teuer).
## Mit einem Rand von einer Kachel ringsum, damit man die Nachbarn fürs Ufer kennt.
var _tiles := {}
var _biomes := {}


## Wird vom World-Knoten aufgerufen, bevor die Zelle in die Szene kommt.
func setup(gen: WorldGen, cell_pos: Vector2i) -> void:
	_gen = gen
	cell = cell_pos
	name = "Cell_%d_%d" % [cell.x, cell.y]
	position = Vector2(cell * WorldGen.CELL_TILES * WorldGen.TILE_SIZE)
	# Etwas größer als die Kachel, weil das gezeichnete Wasser rund übersteht –
	# so bleibt man am Ufer stehen und nicht mit den Füßen im Wasser.
	_wasser_form.size = Vector2.ONE * (WorldGen.TILE_SIZE + 10)
	_rund_form.radius = 18.0
	_compute_tiles()
	_build_obstacles()
	_add_layer("Ground", EBENE_BODEN, _draw_ground)
	_add_layer("Shore", EBENE_UFER, _draw_shore)
	_add_layer("Water", EBENE_WASSER, _draw_water)
	_add_layer("Things", EBENE_DINGE, _draw_things)


## Legt eine Zeichen-Ebene an, die mit „zeichnen" einmal gemalt wird.
func _add_layer(ebenen_name: String, z: int, zeichnen: Callable) -> void:
	var ebene := Node2D.new()
	ebene.name = ebenen_name
	ebene.z_index = z
	ebene.draw.connect(zeichnen.bind(ebene))
	add_child(ebene)


func _compute_tiles() -> void:
	for ly in range(-1, WorldGen.CELL_TILES + 1):
		for lx in range(-1, WorldGen.CELL_TILES + 1):
			var tile := _first_tile() + Vector2i(lx, ly)
			_tiles[tile] = _gen.tile_at(tile)
			_biomes[tile] = _gen.biome_at(tile)


## Erste Kachel (oben links) dieser Zelle.
func _first_tile() -> Vector2i:
	return cell * WorldGen.CELL_TILES


## Mitte einer Kachel, gemessen ab der Ecke dieser Zelle.
func _local_center(tile: Vector2i) -> Vector2:
	return WorldGen.tile_center(tile) - position


func _tile(tile: Vector2i) -> WorldGen.Tile:
	return _tiles[tile]


func _biome(tile: Vector2i) -> WorldGen.Biome:
	return _biomes[tile]


func _build_obstacles() -> void:
	var koerper := StaticBody2D.new()
	koerper.name = "Obstacles"
	add_child(koerper)
	for ly in WorldGen.CELL_TILES:
		for lx in WorldGen.CELL_TILES:
			var tile := _first_tile() + Vector2i(lx, ly)
			var art := _tile(tile)
			if not art in WorldGen.BLOCKING:
				continue
			var form := CollisionShape2D.new()
			form.shape = _wasser_form if art == WorldGen.Tile.WATER else _rund_form
			form.position = _local_center(tile)
			koerper.add_child(form)


## Alle Kacheln dieser Zelle, Zeile für Zeile, mit ihrer Mitte (ab der Zellen-Ecke).
func _each_tile(tue: Callable) -> void:
	for ly in WorldGen.CELL_TILES:
		for lx in WorldGen.CELL_TILES:
			var tile := _first_tile() + Vector2i(lx, ly)
			tue.call(tile, _local_center(tile))


## Ebene 1 – Boden: weiche, überlappende Kreise in der Grasfarbe des Bioms.
## So gehen die Biome sanft ineinander über, ohne Kachel-Kanten.
func _draw_ground(ci: CanvasItem) -> void:
	var t := float(WorldGen.TILE_SIZE)
	ci.draw_rect(Rect2(Vector2.ZERO, Vector2.ONE * t * WorldGen.CELL_TILES), GRAS[WorldGen.Biome.PLAINS][0])
	_each_tile(func(tile: Vector2i, mitte: Vector2) -> void:
		var toene: Array = GRAS[_biome(tile)]
		ci.draw_circle(mitte, t * 0.85, toene[0], true, -1.0, true))
	# Hellere und dunklere Flecken für ein lebendiges Gras
	_each_tile(func(tile: Vector2i, mitte: Vector2) -> void:
		var r := _gen.random_at(tile.x * 13, tile.y * 13)
		if r < 0.05 and _tile(tile) != WorldGen.Tile.WATER:
			var farbe: Color = GRAS[_biome(tile)][2 if r < 0.025 else 1]
			_soft_circle(ci, mitte, t * (1.0 + r * 20.0), farbe))


## Alle Wasser-Kacheln dieser Zelle als Paare [Kachel, Mitte].
func _water_tiles() -> Array:
	var wasser := []
	_each_tile(func(tile: Vector2i, mitte: Vector2) -> void:
		if _tile(tile) == WorldGen.Tile.WATER:
			wasser.append([tile, mitte]))
	return wasser


## Ebene 2 – Ufer: ein Sand-Kreis unter jeder Wasser-Kachel, der etwas übersteht.
func _draw_shore(ci: CanvasItem) -> void:
	for w in _water_tiles():
		ci.draw_circle(w[1], WorldGen.TILE_SIZE * 0.88, UFER, true, -1.0, true)


## Ebene 3 – Wasser: runde Flächen, die zusammen einen See mit weichem Ufer ergeben.
## (Eigene Ebene über dem Ufer, damit kein Sand der Nachbarzelle im See liegt.)
func _draw_water(ci: CanvasItem) -> void:
	var wasser := _water_tiles()
	for w in wasser:
		ci.draw_circle(w[1], WorldGen.TILE_SIZE * 0.72, WASSER, true, -1.0, true)
	# Kleine Wellen auf manchen Wasser-Kacheln
	for w in wasser:
		var tile: Vector2i = w[0]
		if _gen.random_at(tile.x * 5, tile.y * 5) < 0.3:
			ci.draw_arc(w[1], 7.0, PI * 1.15, PI * 1.85, 12, WASSER_HELL, 2.0, true)


## Ebene 4 – Dinge: Grasbüschel, Blumen, Bäume und Felsen.
func _draw_things(ci: CanvasItem) -> void:
	for ly in WorldGen.CELL_TILES:
		for lx in WorldGen.CELL_TILES:
			var tile := _first_tile() + Vector2i(lx, ly)
			var mitte := _local_center(tile)
			match _tile(tile):
				WorldGen.Tile.TREE:
					TreeLook.draw_on(ci, mitte, 1.3)
				WorldGen.Tile.ROCK:
					RockLook.draw_on(ci, mitte)
				WorldGen.Tile.GRASS:
					_draw_grass_details(ci, tile, mitte)


## Grasbüschel und Blumen – nur zur Deko, man kann durchlaufen.
func _draw_grass_details(ci: CanvasItem, tile: Vector2i, mitte: Vector2) -> void:
	var r := _gen.random_at(tile.x * 11, tile.y * 11)
	var versatz := Vector2(_gen.random_at(tile.x, tile.y * 2) - 0.5, _gen.random_at(tile.x * 2, tile.y) - 0.5) * 30.0
	var pos := mitte + versatz
	if r < 0.18:
		var dunkel: Color = GRAS[_biome(tile)][1].darkened(0.15)
		for halm in [-1, 0, 1]:
			ci.draw_line(pos, pos + Vector2(halm * 3, -7 + absi(halm) * 2), dunkel, 2.0, true)
	elif r < 0.24 and _biome(tile) != WorldGen.Biome.FOREST:
		var farbe: Color = BLUMEN[floori(_gen.random_at(tile.y, tile.x) * BLUMEN.size()) % BLUMEN.size()]
		for blatt in 5:
			ci.draw_circle(pos + Vector2.from_angle(TAU * blatt / 5.0) * 3.5, 2.6, farbe, true, -1.0, true)
		ci.draw_circle(pos, 2.0, BLUMEN_MITTE, true, -1.0, true)


## Ein Kreis mit weichem Rand: mehrere fast durchsichtige Kreise übereinander.
func _soft_circle(ci: CanvasItem, mitte: Vector2, radius: float, farbe: Color) -> void:
	farbe.a = 0.12
	for ring in 5:
		ci.draw_circle(mitte, radius * (1.0 - ring * 0.15), farbe, true, -1.0, true)
