# Tests: Die Kamera folgt dem Spieler weich.
extends GutTest

const MainScene := preload("res://scenes/main/main.tscn")

var main: Node
var player: CharacterBody2D
var camera: Camera2D


func before_each() -> void:
	main = MainScene.instantiate()
	add_child_autofree(main)
	player = main.get_node("Player")
	camera = get_viewport().get_camera_2d()
	await wait_physics_frames(2)


func test_kamera_hinkt_kurz_hinterher_und_holt_dann_auf() -> void:
	# Spieler springt plötzlich ein Stück nach rechts.
	player.position += Vector2(300, 0)
	await wait_process_frames(2)
	var abstand_kurz_danach := camera.get_screen_center_position().distance_to(player.global_position)
	assert_gt(abstand_kurz_danach, 50.0, "Kamera springt nicht sofort mit (weich)")

	await wait_seconds(2.0)
	var abstand_spaeter := camera.get_screen_center_position().distance_to(player.global_position)
	assert_lt(abstand_spaeter, 5.0, "Kamera hat den Spieler wieder eingeholt")
