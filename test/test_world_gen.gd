# Tests: Der Weltgenerator macht aus einem Seed immer dieselbe Welt.
extends GutTest


## Alle Kacheln in einem Quadrat um den Ursprung, als Liste.
func _tiles(gen: WorldGen, radius := 40) -> Array:
	var tiles := []
	for y in range(-radius, radius):
		for x in range(-radius, radius):
			tiles.append(gen.tile_at(Vector2i(x, y)))
	return tiles


func test_gleicher_seed_gibt_gleiche_kacheln() -> void:
	assert_eq(_tiles(WorldGen.new(1234)), _tiles(WorldGen.new(1234)))


func test_anderer_seed_gibt_andere_welt() -> void:
	assert_ne(_tiles(WorldGen.new(1234)), _tiles(WorldGen.new(98765)))


func test_gleicher_seed_gibt_gleiche_zelleninhalte() -> void:
	for cell in [Vector2i(0, 0), Vector2i(3, -2), Vector2i(-7, 11)]:
		assert_eq(WorldGen.new(1234).cell_content(cell), WorldGen.new(1234).cell_content(cell))


func test_pflanzen_liegen_auf_gras_in_ihrer_zelle() -> void:
	var gen := WorldGen.new(1234)
	var anzahl := 0
	for cy in range(-3, 3):
		for cx in range(-3, 3):
			var cell := Vector2i(cx, cy)
			for plant in gen.cell_content(cell).plants:
				anzahl += 1
				assert_eq(gen.tile_at(plant.tile), WorldGen.Tile.GRASS, "Pflanze auf Gras")
				assert_eq(WorldGen.cell_of_tile(plant.tile), cell, "Pflanze in ihrer Zelle")
				assert_has(["berry", "mushroom"], plant.kind)
	assert_gt(anzahl, 0, "es gibt Pflanzen")


func test_startpunkt_ist_begehbar() -> void:
	for seed_value in [1, 1234, 98765, 424242, 7]:
		var gen := WorldGen.new(seed_value)
		var start := gen.spawn_tile()
		assert_true(gen.is_walkable(start), "Seed %d: Startkachel begehbar" % seed_value)
		# Man soll auch losgehen können, nicht eingesperrt sein.
		for nachbar in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
			assert_true(gen.is_walkable(start + nachbar), "Seed %d: Nachbar frei" % seed_value)
