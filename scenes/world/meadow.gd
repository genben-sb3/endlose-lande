# Eine große Graswiese mit Grasbüscheln und Blumen, glatt gezeichnet.
# (Die unendliche Welt kommt im nächsten Schritt – das hier ist nur der Boden zum Herumlaufen.)
extends Node2D

## Halbe Kantenlänge der Wiese in Pixeln.
@export var half_size := 2000.0
## Startwert für den Zufall, damit die Wiese jedes Mal gleich aussieht.
@export var seed_value := 1

const GRAS := Color("#8fd36b")
const GRAS_HELL := Color("#a8e07f")
const GRAS_DUNKEL := Color("#6fbf55")
const BLUMEN := [Color("#ffffff"), Color("#ffe066"), Color("#ff8fb1"), Color("#b18cff")]


func _draw() -> void:
	draw_rect(Rect2(-half_size, -half_size, half_size * 2, half_size * 2), GRAS)

	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value

	# Hellere und dunklere Flecken, damit die Wiese lebendig aussieht
	for i in 220:
		var pos := _random_point(rng)
		var farbe: Color = GRAS_HELL if rng.randf() < 0.5 else GRAS_DUNKEL
		farbe.a = 0.45
		draw_circle(pos, rng.randf_range(30, 90), farbe, true, -1.0, true)

	# Grasbüschel: drei kleine Halme
	for i in 900:
		var pos := _random_point(rng)
		for halm in [-1, 0, 1]:
			draw_line(pos, pos + Vector2(halm * 3, -7 + absi(halm) * 2), GRAS_DUNKEL, 2.0, true)

	# Blumen: Blütenblätter um eine gelbe Mitte
	for i in 260:
		var pos := _random_point(rng)
		var farbe: Color = BLUMEN[rng.randi() % BLUMEN.size()]
		for blatt in 5:
			var winkel := TAU * blatt / 5.0
			draw_circle(pos + Vector2.from_angle(winkel) * 3.5, 2.6, farbe, true, -1.0, true)
		draw_circle(pos, 2.0, Color("#ffb703"), true, -1.0, true)


func _random_point(rng: RandomNumberGenerator) -> Vector2:
	return Vector2(rng.randf_range(-half_size, half_size), rng.randf_range(-half_size, half_size))
