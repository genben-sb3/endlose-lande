# Tests: Die Oberwelt in der Hauptszene – Zellen laden, Hindernisse, neues Spiel.
extends GutTest

const MainScene := preload("res://scenes/main/main.tscn")
const SEED := 1234

var main: Node
var player: CharacterBody2D
var world: Node
var gen: WorldGen


func _start(seed_value := SEED) -> void:
	main = MainScene.instantiate()
	main.world_seed = seed_value
	add_child_autofree(main)
	player = main.get_node("Player")
	world = main.get_node("World")
	gen = WorldGen.new(seed_value)
	await wait_physics_frames(2)


## Setzt den Spieler auf eine Kachel und wartet, bis die Welt dort geladen ist.
func _put_player_on(tile: Vector2i) -> void:
	player.position = WorldGen.tile_center(tile)
	await wait_physics_frames(12)  # die Welt lädt eine Zelle pro Bild


## Sucht eine Kachel dieser Art, links davon zwei freie Kacheln (zum Anlaufen).
func _find_obstacle(kind: WorldGen.Tile) -> Vector2i:
	for y in range(-300, 300):
		for x in range(-300, 300):
			var tile := Vector2i(x, y)
			if gen.tile_at(tile) == kind \
					and gen.is_walkable(tile + Vector2i.LEFT) \
					and gen.is_walkable(tile + Vector2i.LEFT * 2) \
					and gen.is_walkable(tile + Vector2i.LEFT + Vector2i.UP) \
					and gen.is_walkable(tile + Vector2i.LEFT + Vector2i.DOWN):
				return tile
	fail_test("keine passende Kachel gefunden")
	return Vector2i.ZERO


func _assert_blocked_by(kind: WorldGen.Tile, name: String) -> void:
	await _start()
	var hindernis := _find_obstacle(kind)
	await _put_player_on(hindernis + Vector2i.LEFT)
	Input.action_press("move_right")
	await wait_physics_frames(60)  # eine Sekunde lang dagegen laufen
	Input.action_release("move_right")
	var linke_kante := hindernis.x * WorldGen.TILE_SIZE
	assert_lt(player.position.x, float(linke_kante), "Spieler bleibt vor %s stehen" % name)
	assert_ne(WorldGen.tile_of_position(player.position), hindernis)


func test_spieler_laeuft_nicht_durch_wasser() -> void:
	await _assert_blocked_by(WorldGen.Tile.WATER, "Wasser")


func test_spieler_laeuft_nicht_durch_baeume() -> void:
	await _assert_blocked_by(WorldGen.Tile.TREE, "Baum")


func test_spieler_laeuft_nicht_durch_felsen() -> void:
	await _assert_blocked_by(WorldGen.Tile.ROCK, "Felsen")


func test_auf_gras_kommt_man_voran() -> void:
	await _start()
	var start := gen.spawn_tile()
	var x_vorher := player.position.x
	Input.action_press("move_left" if gen.is_walkable(start + Vector2i.LEFT * 2) else "move_right")
	await wait_physics_frames(10)
	Input.action_release("move_left")
	Input.action_release("move_right")
	assert_ne(player.position.x, x_vorher, "Spieler hat sich bewegt")


func test_zellen_um_den_spieler_sind_geladen() -> void:
	await _start()
	var mitte := WorldGen.cell_of_tile(WorldGen.tile_of_position(player.position))
	var geladen: Array = world.loaded_cells()
	for dy in [-1, 0, 1]:
		for dx in [-1, 0, 1]:
			assert_has(geladen, mitte + Vector2i(dx, dy))


func test_weit_weg_laufen_laedt_neue_und_entlaedt_alte_zellen() -> void:
	await _start()
	var alte_mitte := WorldGen.cell_of_tile(WorldGen.tile_of_position(player.position))
	var anzahl_vorher: int = world.loaded_cells().size()
	# 10 Zellen weiter nach rechts springen
	player.position += Vector2(10 * WorldGen.CELL_TILES * WorldGen.TILE_SIZE, 0)
	await wait_physics_frames(20)
	var neue_mitte := WorldGen.cell_of_tile(WorldGen.tile_of_position(player.position))
	var geladen: Array = world.loaded_cells()
	assert_has(geladen, neue_mitte, "neue Zelle geladen")
	assert_does_not_have(geladen, alte_mitte, "alte Zelle entladen")
	assert_eq(geladen.size(), anzahl_vorher, "es werden nicht immer mehr Zellen")


func test_neues_spiel_startet_auf_dem_startpunkt() -> void:
	await _start()
	assert_eq(WorldGen.tile_of_position(player.position), gen.spawn_tile())


func test_jedes_neue_spiel_hat_einen_zufaelligen_seed() -> void:
	var seeds := []
	for i in 3:
		var neu := MainScene.instantiate()
		add_child_autofree(neu)
		seeds.append(neu.world_seed)
	assert_ne(seeds[0], seeds[1])
	assert_ne(seeds[1], seeds[2])


func test_man_sieht_nie_ungeladene_welt() -> void:
	await _start()
	# Schlimmster Fall: Der Spieler steht genau in der Ecke einer Zelle.
	var zelle_px := WorldGen.CELL_TILES * WorldGen.TILE_SIZE
	var ecke := WorldGen.cell_of_tile(WorldGen.tile_of_position(player.position)) * zelle_px
	player.position = Vector2(ecke) + Vector2(2, 2)
	await wait_physics_frames(15)
	var camera: Camera2D = player.get_node("Camera")
	camera.reset_smoothing()
	var sichtbar_halb := get_viewport().get_visible_rect().size / camera.zoom / 2.0
	var geladen: Array = world.loaded_cells()
	for punkt in [Vector2(-1, -1), Vector2(1, -1), Vector2(-1, 1), Vector2(1, 1)]:
		var bild_ecke: Vector2 = player.global_position + punkt * sichtbar_halb
		var zelle := WorldGen.cell_of_tile(WorldGen.tile_of_position(bild_ecke))
		assert_has(geladen, zelle, "Bild-Ecke %s ist geladen" % punkt)


func test_kamera_ist_herausgezoomt() -> void:
	await _start()
	var camera: Camera2D = player.get_node("Camera")
	assert_lt(camera.zoom.x, 1.0, "man sieht mehr von der Welt")
