# Die Hauptszene: Oberwelt, Spieler und der Hinweis zur Steuerung.
extends Node2D

## Der Seed der Welt. 0 heißt: neues Spiel mit einem zufälligen Seed.
@export var world_seed := 0


func _ready() -> void:
	if world_seed == 0:
		world_seed = randi_range(1, 2147483647)
	var gen := WorldGen.new(world_seed)

	# Spieler auf den Startpunkt stellen; die Kamera springt direkt mit (nicht weich hinübergleiten)
	$Player.position = WorldGen.tile_center(gen.spawn_tile())
	$Player/Camera.reset_smoothing()
	$World.setup(gen, $Player)

	# Alle Spieltexte laufen über tr(), damit man sie später übersetzen kann.
	$UI/Hint.text = tr("HINT_MOVE")
