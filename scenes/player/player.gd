# Die Spielfigur: läuft mit WASD bzw. den Pfeiltasten.
extends CharacterBody2D

## Lauf-Tempo in Pixeln pro Sekunde (aus der Web-Version übernommen).
@export var speed := 220.0


func _physics_process(_delta: float) -> void:
	# get_vector macht die Richtung gleich lang (höchstens 1),
	# deshalb ist man schräg nicht schneller als geradeaus.
	var richtung := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = richtung * speed
	move_and_slide()
