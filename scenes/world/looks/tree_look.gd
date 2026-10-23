# Wie ein Baum aussieht: runde, weiche Baumkrone auf einem kleinen Stamm.
# Passt genau in eine Kachel. Später kann hier ein gemaltes Bild gezeichnet werden.
class_name TreeLook

const STAMM := Color("#8a5a3b")
const KRONE_DUNKEL := Color("#3f8f4a")
const KRONE := Color("#52a95a")
const KRONE_HELL := Color("#7cc77a")


## Zeichnet einen Baum mit Mittelpunkt „mitte" auf die Zeichenfläche „ci".
static func draw_on(ci: CanvasItem, mitte: Vector2, groesse := 1.0) -> void:
	var s := groesse
	Shapes.ellipse(ci, mitte + Vector2(0, 17) * s, Vector2(17, 6) * s, Color(0, 0, 0, 0.18))
	ci.draw_rect(Rect2(mitte + Vector2(-3, 4) * s, Vector2(6, 13) * s), STAMM)
	ci.draw_circle(mitte + Vector2(0, -3) * s, 17.0 * s, KRONE_DUNKEL, true, -1.0, true)
	ci.draw_circle(mitte + Vector2(-2, -5) * s, 14.0 * s, KRONE, true, -1.0, true)
	ci.draw_circle(mitte + Vector2(-6, -10) * s, 5.5 * s, KRONE_HELL, true, -1.0, true)
