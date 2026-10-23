# Ein Felsen: ein rundlicher grauer Brocken mit Glanzlicht, glatt gezeichnet.
# Eigene Szene (rock.tscn) – später kann man hier einfach ein gemaltes Bild einsetzen.
# Durchlaufen kann man ihn nicht; das Hindernis baut die Zelle (world_cell.gd).
extends Node2D

const FELS_DUNKEL := Color("#7d8591")
const FELS := Color("#9aa3ae")
const FELS_HELL := Color("#c3cad3")


func _draw() -> void:
	Shapes.ellipse(self, Vector2(0, 14), Vector2(19, 6), Color(0, 0, 0, 0.18))
	Shapes.ellipse(self, Vector2(0, 2), Vector2(19, 15), FELS_DUNKEL)
	Shapes.ellipse(self, Vector2(-1, -1), Vector2(16, 12), FELS)
	Shapes.ellipse(self, Vector2(-6, -6), Vector2(5, 3), FELS_HELL)
