# Tests: Spieltexte kommen aus der Übersetzung (tr()), nicht direkt aus dem Code.
extends GutTest

const MainScene := preload("res://scenes/main/main.tscn")


func test_steuerungs_hinweis_ist_deutsch() -> void:
	var main := MainScene.instantiate()
	add_child_autofree(main)
	var hint: Label = main.get_node("UI/Hint")
	assert_eq(hint.text, "Laufen: WASD oder Pfeiltasten")
