# Ein Baum: runde, weiche Baumkrone auf einem kleinen Stamm, glatt gezeichnet.
# Eigene Szene (tree.tscn) – später kann man hier einfach ein gemaltes Bild einsetzen.
# Durchlaufen kann man ihn nicht; das Hindernis baut die Zelle (world_cell.gd).
extends Node2D

const STAMM := Color("#8a5a3b")
const KRONE_DUNKEL := Color("#3f8f4a")
const KRONE := Color("#52a95a")
const KRONE_HELL := Color("#7cc77a")


func _draw() -> void:
	Shapes.ellipse(self, Vector2(0, 17), Vector2(17, 6), Color(0, 0, 0, 0.18))
	draw_rect(Rect2(Vector2(-3, 4), Vector2(6, 13)), STAMM)
	draw_circle(Vector2(0, -3), 17.0, KRONE_DUNKEL, true, -1.0, true)
	draw_circle(Vector2(-2, -5), 14.0, KRONE, true, -1.0, true)
	draw_circle(Vector2(-6, -10), 5.5, KRONE_HELL, true, -1.0, true)
