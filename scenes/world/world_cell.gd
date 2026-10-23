# Eine Zelle der Oberwelt (22 × 22 Kacheln): zeichnet Boden, Ufer und Wasser, stellt Bäume
# und Felsen auf (eigene Szenen) und baut die Hindernisse, durch die man nicht laufen kann.
#
# Boden, Ufer und Wasser werden in eigenen Ebenen (z-Index) gezeichnet. Godot merkt sich die
# Zeichenbefehle nach dem Laden und spielt sie jedes Bild nur ab – gerechnet wird nur einmal.
# Weiche Formen ragen etwas in die Nachbarzelle hinein; durch die Ebenen deckt der Boden
# der Nachbarzelle sie nicht zu.
extends Node2D

const TreeScene := preload("res://scenes/world/tree.tscn")
const RockScene := preload("res://scenes/world/rock.tscn")

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

## Wie oft etwas auf einer Gras-Kachel liegt (0 bis 1).
const ANTEIL_BUESCHEL := 0.18
const ANTEIL_BLUMEN := 0.06
const ANTEIL_FLECKEN := 0.05
const ANTEIL_WELLEN := 0.3

## Zahlen, mit denen random_at für jede Sache einen eigenen Zufall bekommt
## (sonst stünde z. B. auf jeder Kachel mit Blume auch ein Grasbüschel).
const ZUFALL_DEKO := 11
const ZUFALL_FLECKEN := 13
const ZUFALL_WELLEN := 5

## Alle Hindernisse teilen sich dieselben zwei Formen – das spart Speicher.
## Das Wasser-Hindernis ist etwas größer als die Kachel, weil das gezeichnete Wasser rund
## übersteht – so bleibt man am Ufer stehen und nicht mit den Füßen im Wasser.
static var _wasser_form := _make_rect(WorldGen.TILE_SIZE + 10)
static var _rund_form := _make_circle(18.0)

var cell: Vector2i
var _gen: WorldGen
## Kachel-Art und Biom jeder Kachel, einmal beim Laden ausgerechnet (Rauschen ist teuer).
## Mit einem Rand von einer Kachel ringsum, damit man die Nachbarn fürs Ufer kennt.
var _tiles := {}
var _biomes := {}


static func _make_rect(groesse: float) -> RectangleShape2D:
	var form := RectangleShape2D.new()
	form.size = Vector2.ONE * groesse
	return form


static func _make_circle(radius: float) -> CircleShape2D:
	var form := CircleShape2D.new()
	form.radius = radius
	return form


## Wird vom World-Knoten aufgerufen, bevor die Zelle in die Szene kommt.
func setup(gen: WorldGen, cell_pos: Vector2i) -> void:
	_gen = gen
	cell = cell_pos
	name = "Cell_%d_%d" % [cell.x, cell.y]
	position = Vector2(cell * WorldGen.CELL_TILES * WorldGen.TILE_SIZE)
	_compute_tiles()
	_build_obstacles()
	_add_layer("Ground", EBENE_BODEN, _draw_ground)
	_add_layer("Shore", EBENE_UFER, _draw_shore)
	_add_layer("Water", EBENE_WASSER, _draw_water)
	_place_things(_add_layer("Things", EBENE_DINGE, _draw_grass_details))


func _compute_tiles() -> void:
	for ly in range(-1, WorldGen.CELL_TILES + 1):
		for lx in range(-1, WorldGen.CELL_TILES + 1):
			var tile := _first_tile() + Vector2i(lx, ly)
			_tiles[tile] = _gen.tile_at(tile)
			_biomes[tile] = _gen.biome_at(tile)


## Legt eine Zeichen-Ebene an, die mit „zeichnen" einmal gemalt wird.
func _add_layer(ebenen_name: String, z: int, zeichnen: Callable) -> Node2D:
	var ebene := Node2D.new()
	ebene.name = ebenen_name
	ebene.z_index = z
	ebene.draw.connect(zeichnen.bind(ebene))
	add_child(ebene)
	return ebene


# ---- Kacheln dieser Zelle ----------------------------------------------------

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


## Alle Kacheln dieser Zelle, Zeile für Zeile.
func _cell_tiles() -> Array[Vector2i]:
	var kacheln: Array[Vector2i] = []
	for ly in WorldGen.CELL_TILES:
		for lx in WorldGen.CELL_TILES:
			kacheln.append(_first_tile() + Vector2i(lx, ly))
	return kacheln


## Alle Kacheln dieser Zelle von einer bestimmten Art.
func _tiles_of(art: WorldGen.Tile) -> Array[Vector2i]:
	return _cell_tiles().filter(func(tile: Vector2i) -> bool: return _tile(tile) == art)


# ---- Hindernisse und Dinge -----------------------------------------------------

func _build_obstacles() -> void:
	var koerper := StaticBody2D.new()
	koerper.name = "Obstacles"
	add_child(koerper)
	for tile in _cell_tiles():
		var art := _tile(tile)
		if not art in WorldGen.BLOCKING:
			continue
		var form := CollisionShape2D.new()
		form.shape = _wasser_form if art == WorldGen.Tile.WATER else _rund_form
		form.position = _local_center(tile)
		koerper.add_child(form)


## Stellt Bäume und Felsen als eigene Szenen auf.
func _place_things(ebene: Node2D) -> void:
	for tile in _tiles_of(WorldGen.Tile.TREE):
		_place(TreeScene, tile, ebene)
	for tile in _tiles_of(WorldGen.Tile.ROCK):
		_place(RockScene, tile, ebene)


func _place(szene: PackedScene, tile: Vector2i, ebene: Node2D) -> void:
	var ding: Node2D = szene.instantiate()
	ding.position = _local_center(tile)
	ebene.add_child(ding)


# ---- Zeichnen ------------------------------------------------------------------

## Boden: weiche, überlappende Kreise in der Grasfarbe des Bioms.
## So gehen die Biome sanft ineinander über, ohne Kachel-Kanten.
func _draw_ground(ci: CanvasItem) -> void:
	var t := float(WorldGen.TILE_SIZE)
	ci.draw_rect(Rect2(Vector2.ZERO, Vector2.ONE * t * WorldGen.CELL_TILES), GRAS[WorldGen.Biome.PLAINS][0])
	for tile in _cell_tiles():
		ci.draw_circle(_local_center(tile), t * 0.85, GRAS[_biome(tile)][0], true, -1.0, true)
	# Hellere und dunklere Flecken für ein lebendiges Gras
	for tile in _cell_tiles():
		var r := _gen.random_at(tile.x * ZUFALL_FLECKEN, tile.y * ZUFALL_FLECKEN)
		if r < ANTEIL_FLECKEN and _tile(tile) != WorldGen.Tile.WATER:
			var farbe: Color = GRAS[_biome(tile)][2 if r < ANTEIL_FLECKEN / 2 else 1]
			_soft_circle(ci, _local_center(tile), t * (1.0 + r * 20.0), farbe)


## Ufer: ein Sand-Kreis unter jeder Wasser-Kachel, der etwas übersteht.
func _draw_shore(ci: CanvasItem) -> void:
	for tile in _tiles_of(WorldGen.Tile.WATER):
		ci.draw_circle(_local_center(tile), WorldGen.TILE_SIZE * 0.88, UFER, true, -1.0, true)


## Wasser: runde Flächen, die zusammen einen See mit weichem Ufer ergeben.
## (Eigene Ebene über dem Ufer, damit kein Sand der Nachbarzelle im See liegt.)
func _draw_water(ci: CanvasItem) -> void:
	var wasser := _tiles_of(WorldGen.Tile.WATER)
	for tile in wasser:
		ci.draw_circle(_local_center(tile), WorldGen.TILE_SIZE * 0.72, WASSER, true, -1.0, true)
	for tile in wasser:
		if _gen.random_at(tile.x * ZUFALL_WELLEN, tile.y * ZUFALL_WELLEN) < ANTEIL_WELLEN:
			ci.draw_arc(_local_center(tile), 7.0, PI * 1.15, PI * 1.85, 12, WASSER_HELL, 2.0, true)


## Grasbüschel und Blumen – nur Deko auf dem Boden, man kann durchlaufen.
func _draw_grass_details(ci: CanvasItem) -> void:
	for tile in _tiles_of(WorldGen.Tile.GRASS):
		var r := _gen.random_at(tile.x * ZUFALL_DEKO, tile.y * ZUFALL_DEKO)
		var versatz := Vector2(_gen.random_at(tile.x, tile.y * 2) - 0.5, _gen.random_at(tile.x * 2, tile.y) - 0.5) * 30.0
		var pos := _local_center(tile) + versatz
		if r < ANTEIL_BUESCHEL:
			var dunkel: Color = GRAS[_biome(tile)][1].darkened(0.15)
			for halm in [-1, 0, 1]:
				ci.draw_line(pos, pos + Vector2(halm * 3, -7 + absi(halm) * 2), dunkel, 2.0, true)
		elif r < ANTEIL_BUESCHEL + ANTEIL_BLUMEN and _biome(tile) != WorldGen.Biome.FOREST:
			var farbe: Color = BLUMEN[floori(_gen.random_at(tile.y, tile.x) * BLUMEN.size()) % BLUMEN.size()]
			for blatt in 5:
				ci.draw_circle(pos + Vector2.from_angle(TAU * blatt / 5.0) * 3.5, 2.6, farbe, true, -1.0, true)
			ci.draw_circle(pos, 2.0, BLUMEN_MITTE, true, -1.0, true)


## Ein Kreis mit weichem Rand: mehrere fast durchsichtige Kreise übereinander.
func _soft_circle(ci: CanvasItem, mitte: Vector2, radius: float, farbe: Color) -> void:
	farbe.a = 0.12
	for ring in 5:
		ci.draw_circle(mitte, radius * (1.0 - ring * 0.15), farbe, true, -1.0, true)
