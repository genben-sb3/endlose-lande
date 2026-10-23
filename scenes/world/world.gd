# Welt-Streaming: lädt die Zellen der Oberwelt rund um den Spieler und entlädt weit entfernte.
# So ist die Welt unendlich, aber es ist immer nur ein kleines Stück im Speicher.
extends Node2D

const WorldCellScene := preload("res://scenes/world/world_cell.tscn")

## So viele Zellen in jede Richtung um den Spieler werden geladen (1 → 3 × 3 Zellen).
## Muss reichen, damit man auch mit herausgezoomter Kamera keine leeren Stellen sieht
## (das prüft test_man_sieht_nie_ungeladene_welt).
const LOAD_RADIUS := 1
## Erst ab diesem Abstand wird eine Zelle wieder entladen. Der Abstand ist größer als
## LOAD_RADIUS, damit eine Zelle nicht dauernd lädt und entlädt, wenn man an der Grenze hin- und herläuft.
const UNLOAD_RADIUS := 2
## Höchstens so viele Zellen pro Bild laden, damit das Spiel beim Laufen nicht ruckelt.
const CELLS_PER_FRAME := 1

var generator: WorldGen
var _target: Node2D
## Geladene Zellen: Zellen-Koordinate → Zellen-Knoten
var _cells := {}


## Startet das Streaming für diese Welt rund um „target" (den Spieler).
## Die Zellen direkt um den Spieler werden sofort geladen, damit man nicht ins Leere startet.
func setup(gen: WorldGen, target: Node2D) -> void:
	generator = gen
	_target = target
	for c in _cells.values():
		c.queue_free()
	_cells.clear()
	_update(true)


## Welche Zellen gerade geladen sind.
func loaded_cells() -> Array:
	return _cells.keys()


func _physics_process(_delta: float) -> void:
	if generator != null:
		_update(false)


## Lädt fehlende und entlädt ferne Zellen. Mit „alles_sofort" werden alle fehlenden
## Zellen auf einmal geladen, sonst höchstens CELLS_PER_FRAME.
func _update(alles_sofort: bool) -> void:
	var mitte := WorldGen.cell_of_tile(WorldGen.tile_of_position(_target.global_position))

	# Weit entfernte Zellen entladen
	for c in _cells.keys():
		if _distance(c, mitte) > UNLOAD_RADIUS:
			_cells[c].queue_free()
			_cells.erase(c)

	# Fehlende Zellen laden – die nächsten zuerst
	var fehlend := []
	for dy in range(-LOAD_RADIUS, LOAD_RADIUS + 1):
		for dx in range(-LOAD_RADIUS, LOAD_RADIUS + 1):
			var c := mitte + Vector2i(dx, dy)
			if not _cells.has(c):
				fehlend.append(c)
	fehlend.sort_custom(func(a, b): return Vector2(a - mitte).length() < Vector2(b - mitte).length())
	var anzahl := fehlend.size() if alles_sofort else mini(fehlend.size(), CELLS_PER_FRAME)
	for i in anzahl:
		_load_cell(fehlend[i])


func _load_cell(c: Vector2i) -> void:
	var zelle := WorldCellScene.instantiate()
	zelle.setup(generator, c)
	add_child(zelle)
	_cells[c] = zelle


## Abstand zweier Zellen in „Zellen-Schritten" (schräg zählt wie gerade).
func _distance(a: Vector2i, b: Vector2i) -> int:
	return maxi(absi(a.x - b.x), absi(a.y - b.y))
