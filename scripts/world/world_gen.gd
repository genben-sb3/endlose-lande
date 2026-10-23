# Der Weltgenerator: macht aus einem Seed (Zufalls-Startwert) die ganze, unendliche Oberwelt.
# Er ist eine „reine Funktion": Gleicher Seed + gleiche Stelle → immer dieselbe Antwort.
# Er kennt keine Szenen und zeichnet nichts – er beantwortet nur Fragen wie
# „Welche Kachel liegt hier?", „Welches Biom ist hier?" und „Was liegt in dieser Zelle?".
# (Vorlage: world.js aus der Web-Version.)
class_name WorldGen
extends RefCounted

## Wie groß eine Kachel in Pixeln ist.
const TILE_SIZE := 48
## Wie viele Kacheln eine Zelle breit und hoch ist. Die Welt wird zellenweise geladen.
const CELL_TILES := 22

enum Tile { GRASS, TREE, WATER, ROCK }
enum Biome { MEADOW, PLAINS, FOREST, ROCKY, LAKE }

## Grenzwerte für Höhe und Feuchte (0 bis 1). Sie bestimmen, wie viel von jedem Biom es gibt.
## Eingestellt auf ähnliche Anteile wie in der Web-Version (nachgemessen mit Seed 1234):
## etwa 7 % See, 4 % Felsland, 20 % Wald und 21 % Wiese, der Rest ist Ebene.
const SEE_UNTER := 0.26
const FELSLAND_UEBER := 0.735
const WALD_UEBER := 0.58
const WIESE_UNTER := 0.36

## Wie dicht Felsen im Felsland und Bäume im Wald stehen (0 bis 1).
const FELS_DICHTE := 0.25
const BAUM_DICHTE := 0.32
## Zahlen, mit denen random_at für Felsen und Bäume je einen eigenen Zufall bekommt.
const ZUFALL_FELS := 3
const ZUFALL_BAUM := 7

## Durch diese Kacheln kann man nicht laufen.
const BLOCKING := [Tile.TREE, Tile.WATER, Tile.ROCK]

var world_seed: int
## Rauschen für Höhe und Feuchte. FastNoiseLite ist in Godot eingebaut und viel schneller
## als selbst gerechnetes Rauschen – wichtig, damit das Laden neuer Zellen nicht ruckelt.
var _hoehe := FastNoiseLite.new()
var _feuchte := FastNoiseLite.new()


func _init(seed_value: int) -> void:
	world_seed = seed_value
	# Wie in der Web-Version (fbm): weiches Wert-Rauschen, 3 Schichten (große Hügel + Details)
	for rauschen in [_hoehe, _feuchte]:
		rauschen.noise_type = FastNoiseLite.TYPE_VALUE
		rauschen.fractal_type = FastNoiseLite.FRACTAL_FBM
		rauschen.fractal_octaves = 3
		rauschen.fractal_lacunarity = 2.0
		rauschen.fractal_gain = 0.5
	_hoehe.seed = seed_value
	_hoehe.frequency = 0.035
	_feuchte.seed = seed_value + 1
	_feuchte.frequency = 0.045


## Welche Kachel liegt an dieser Stelle? Sie hängt vom Biom ab:
## im See Wasser, im Felsland manchmal ein Fels, im Wald manchmal ein Baum, sonst Gras.
func tile_at(tile: Vector2i) -> Tile:
	match biome_at(tile):
		Biome.LAKE:
			return Tile.WATER
		Biome.ROCKY:
			if random_at(tile.x * ZUFALL_FELS, tile.y * ZUFALL_FELS) < FELS_DICHTE:
				return Tile.ROCK
		Biome.FOREST:
			if random_at(tile.x * ZUFALL_BAUM, tile.y * ZUFALL_BAUM) < BAUM_DICHTE:
				return Tile.TREE
	return Tile.GRASS


## Welches Biom ist an dieser Stelle?
func biome_at(tile: Vector2i) -> Biome:
	var hoehe := _elevation(tile)
	var feuchte := _moisture(tile)
	if hoehe < SEE_UNTER:
		return Biome.LAKE
	if hoehe > FELSLAND_UEBER:
		return Biome.ROCKY
	if feuchte > WALD_UEBER:
		return Biome.FOREST
	if feuchte < WIESE_UNTER:
		return Biome.MEADOW
	return Biome.PLAINS


## Kann man auf dieser Kachel stehen?
func is_walkable(tile: Vector2i) -> bool:
	return not tile_at(tile) in BLOCKING


## Was liegt in dieser Zelle? Im Moment: Pflanzen zum Sammeln (Beeren und Pilze).
## Ergebnis: { "plants": [ { "id", "tile", "kind" }, … ] }
## Die „id" bleibt immer gleich – damit merkt sich der Spielstand später, was schon eingesammelt ist.
func cell_content(cell: Vector2i) -> Dictionary:
	var erste := cell * CELL_TILES
	var plants := []
	var anzahl := 2 + floori(random_at(cell.x + 7, cell.y + 11) * 3)
	for i in anzahl:
		var tile := erste + Vector2i(
			floori(random_at(cell.x * 23 + i, cell.y + 3) * CELL_TILES),
			floori(random_at(cell.x + 3, cell.y * 23 + i) * CELL_TILES))
		if tile_at(tile) == Tile.GRASS:
			plants.append({
				"id": "wp:%d:%d:%d" % [cell.x, cell.y, i],
				"tile": tile,
				"kind": "berry" if random_at(tile.x, tile.y) < 0.5 else "mushroom",
			})
	return { "plants": plants }


## Wo der Spieler in einem neuen Spiel startet: die nächste freie Kachel beim Ursprung,
## um die herum man auch in alle Richtungen losgehen kann.
func spawn_tile() -> Vector2i:
	# Spirale vom Ursprung nach außen absuchen
	for radius in range(0, 500):
		for y in range(-radius, radius + 1):
			for x in range(-radius, radius + 1):
				if maxi(absi(x), absi(y)) != radius:
					continue  # nur den Rand dieses Quadrats prüfen
				var tile := Vector2i(x, y)
				if _has_room(tile):
					return tile
	return Vector2i.ZERO


## Ist die Kachel frei und auch alle vier Nachbarn?
func _has_room(tile: Vector2i) -> bool:
	if not is_walkable(tile):
		return false
	for nachbar in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
		if not is_walkable(tile + nachbar):
			return false
	return true


## In welcher Zelle liegt diese Kachel?
static func cell_of_tile(tile: Vector2i) -> Vector2i:
	return Vector2i(floori(tile.x / float(CELL_TILES)), floori(tile.y / float(CELL_TILES)))


## In welcher Kachel liegt dieser Punkt (in Pixeln)?
static func tile_of_position(pos: Vector2) -> Vector2i:
	return Vector2i(floori(pos.x / TILE_SIZE), floori(pos.y / TILE_SIZE))


## Die Mitte einer Kachel in Pixeln.
static func tile_center(tile: Vector2i) -> Vector2:
	return (Vector2(tile) + Vector2(0.5, 0.5)) * TILE_SIZE


# ---- Zufall und Rauschen -----------------------------------------------------

## Eine Zufallszahl von 0 bis 1, die nur von (a, b) und dem Seed abhängt.
## Gleiche Eingabe → gleiche Zahl. (Ein „Hash" wie in der Web-Version.)
func random_at(a: int, b: int) -> float:
	var h := (_mul32(a, 73856093) ^ _mul32(b, 19349663) ^ _mul32(world_seed, 83492791)) & 0xFFFFFFFF
	h = _mul32(h ^ (h >> 15), 2246822519)
	h ^= h >> 13
	h = _mul32(h, 3266489917)
	h ^= h >> 16
	return float(h) / 4294967295.0


## Multipliziert wie in JavaScript mit 32 Bit (Math.imul), damit der Zufall gut verteilt ist.
func _mul32(a: int, b: int) -> int:
	return ((a & 0xFFFFFFFF) * (b & 0xFFFFFFFF)) & 0xFFFFFFFF


## Die Höhe des Geländes (0 = tief → Wasser, 1 = hoch → Felsen).
func _elevation(tile: Vector2i) -> float:
	return (_hoehe.get_noise_2d(tile.x, tile.y) + 1.0) * 0.5


## Wie feucht der Boden ist (feucht → Wald, trocken → Wiese).
func _moisture(tile: Vector2i) -> float:
	return (_feuchte.get_noise_2d(tile.x, tile.y) + 1.0) * 0.5
