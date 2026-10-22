# Tests: Der Spieler läuft mit WASD bzw. den Pfeiltasten.
extends GutTest

const PlayerScene := preload("res://scenes/player/player.tscn")

var player: CharacterBody2D


func before_each() -> void:
	player = PlayerScene.instantiate()
	add_child_autofree(player)


## Drückt Tasten wie auf einer echten Tastatur, hält sie ein paar
## Physik-Schritte lang gedrückt und gibt zurück, wie weit der Spieler lief.
func _walk(keys: Array, frames := 10) -> Vector2:
	for key in keys:
		_send_key(key, true)
	# Erst einen Schritt abwarten, damit nur das Laufen mit fest
	# gedrückten Tasten gemessen wird.
	await wait_physics_frames(1)
	var start := player.position
	await wait_physics_frames(frames)
	var weg := player.position - start
	for key in keys:
		_send_key(key, false)
	await wait_physics_frames(1)
	return weg


## Schickt einen Tastendruck (oder das Loslassen) an Godot, wie eine echte Tastatur.
func _send_key(key: Key, pressed: bool) -> void:
	var event := InputEventKey.new()
	event.physical_keycode = key
	event.pressed = pressed
	Input.parse_input_event(event)
	Input.flush_buffered_events()


## Prüft, dass der Weg in die erwartete Richtung zeigt.
func _assert_direction(weg: Vector2, erwartet: Vector2) -> void:
	assert_gt(weg.length(), 1.0, "Spieler hat sich bewegt")
	assert_almost_eq(weg.normalized().dot(erwartet), 1.0, 0.001,
		"Richtung %s statt %s" % [weg.normalized(), erwartet])


func test_wasd_bewegt_in_die_richtige_richtung() -> void:
	_assert_direction(await _walk([KEY_W]), Vector2.UP)
	_assert_direction(await _walk([KEY_A]), Vector2.LEFT)
	_assert_direction(await _walk([KEY_S]), Vector2.DOWN)
	_assert_direction(await _walk([KEY_D]), Vector2.RIGHT)


func test_pfeiltasten_bewegen_in_die_richtige_richtung() -> void:
	_assert_direction(await _walk([KEY_UP]), Vector2.UP)
	_assert_direction(await _walk([KEY_LEFT]), Vector2.LEFT)
	_assert_direction(await _walk([KEY_DOWN]), Vector2.DOWN)
	_assert_direction(await _walk([KEY_RIGHT]), Vector2.RIGHT)


func test_ohne_taste_bleibt_der_spieler_stehen() -> void:
	var weg := await _walk([])
	assert_eq(weg, Vector2.ZERO)


func test_schraeg_laufen_ist_nicht_schneller() -> void:
	var gerade := await _walk([KEY_D])
	var schraeg := await _walk([KEY_D, KEY_S])
	_assert_direction(schraeg, Vector2(1, 1).normalized())
	assert_almost_eq(schraeg.length(), gerade.length(), 0.5,
		"schräg gleich weit wie geradeaus")
