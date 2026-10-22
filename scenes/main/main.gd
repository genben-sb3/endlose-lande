# Die Hauptszene: Wiese, Spieler und der Hinweis zur Steuerung.
extends Node2D


func _ready() -> void:
	# Alle Spieltexte laufen über tr(), damit man sie später übersetzen kann.
	$UI/Hint.text = tr("HINT_MOVE")
