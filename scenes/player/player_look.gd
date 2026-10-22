# Das Aussehen der Spielfigur: glatt gezeichnet, ohne Pixel.
# Später kann man diesen Knoten einfach durch ein gemaltes Bild ersetzen.
extends Node2D

const HAUT := Color("#ffd9b3")
const UMHANG := Color("#4a8fe7")
const HAARE := Color("#7a4a2a")
const AUGEN := Color("#2b2233")


func _draw() -> void:
	# Weicher Schatten am Boden
	_ellipse(Vector2(0, 14), Vector2(15, 6), Color(0, 0, 0, 0.18))
	# Körper (Umhang)
	_ellipse(Vector2(0, 4), Vector2(12, 13), UMHANG)
	# Kopf
	draw_circle(Vector2(0, -12), 11.0, HAUT, true, -1.0, true)
	# Haare oben auf dem Kopf
	draw_arc(Vector2(0, -12), 10.0, PI * 1.05, PI * 1.95, 24, HAARE, 6.0, true)
	# Augen
	draw_circle(Vector2(-4, -12), 1.8, AUGEN, true, -1.0, true)
	draw_circle(Vector2(4, -12), 1.8, AUGEN, true, -1.0, true)


## Zeichnet eine gefüllte, glatte Ellipse.
func _ellipse(mitte: Vector2, radien: Vector2, farbe: Color) -> void:
	var punkte := PackedVector2Array()
	for i in 32:
		var winkel := TAU * i / 32.0
		punkte.append(mitte + Vector2(cos(winkel) * radien.x, sin(winkel) * radien.y))
	draw_colored_polygon(punkte, farbe)
	draw_polyline(punkte + PackedVector2Array([punkte[0]]), farbe, 1.0, true)
