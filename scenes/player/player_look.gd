# Das Aussehen der Spielfigur: glatt gezeichnet, ohne Pixel.
# Später kann man diesen Knoten einfach durch ein gemaltes Bild ersetzen.
extends Node2D

const HAUT := Color("#ffd9b3")
const UMHANG := Color("#4a8fe7")
const HAARE := Color("#7a4a2a")
const AUGEN := Color("#2b2233")


func _draw() -> void:
	# Weicher Schatten am Boden
	Shapes.ellipse(self, Vector2(0, 14), Vector2(15, 6), Color(0, 0, 0, 0.18))
	# Körper (Umhang)
	Shapes.ellipse(self, Vector2(0, 4), Vector2(12, 13), UMHANG)
	# Kopf
	draw_circle(Vector2(0, -12), 11.0, HAUT, true, -1.0, true)
	# Haare oben auf dem Kopf
	draw_arc(Vector2(0, -12), 10.0, PI * 1.05, PI * 1.95, 24, HAARE, 6.0, true)
	# Augen
	draw_circle(Vector2(-4, -12), 1.8, AUGEN, true, -1.0, true)
	draw_circle(Vector2(4, -12), 1.8, AUGEN, true, -1.0, true)

