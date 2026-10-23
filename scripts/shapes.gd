# Kleine Zeichen-Helfer für glatte Formen, die Godot nicht schon kann.
class_name Shapes


## Zeichnet eine gefüllte, glatte Ellipse.
static func ellipse(ci: CanvasItem, mitte: Vector2, radien: Vector2, farbe: Color) -> void:
	var punkte := PackedVector2Array()
	for i in 32:
		var winkel := TAU * i / 32.0
		punkte.append(mitte + Vector2(cos(winkel) * radien.x, sin(winkel) * radien.y))
	ci.draw_colored_polygon(punkte, farbe)
	ci.draw_polyline(punkte + PackedVector2Array([punkte[0]]), farbe, 1.0, true)
