# Wie ein Felsen aussieht: ein rundlicher grauer Brocken mit Glanzlicht.
# Passt genau in eine Kachel. Später kann hier ein gemaltes Bild gezeichnet werden.
class_name RockLook

const FELS_DUNKEL := Color("#7d8591")
const FELS := Color("#9aa3ae")
const FELS_HELL := Color("#c3cad3")


## Zeichnet einen Felsen mit Mittelpunkt „mitte" auf die Zeichenfläche „ci".
static func draw_on(ci: CanvasItem, mitte: Vector2) -> void:
	Shapes.ellipse(ci, mitte + Vector2(0, 14), Vector2(19, 6), Color(0, 0, 0, 0.18))
	Shapes.ellipse(ci, mitte + Vector2(0, 2), Vector2(19, 15), FELS_DUNKEL)
	Shapes.ellipse(ci, mitte + Vector2(-1, -1), Vector2(16, 12), FELS)
	Shapes.ellipse(ci, mitte + Vector2(-6, -6), Vector2(5, 3), FELS_HELL)
