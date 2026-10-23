# Macht Screenshots vom Spiel, ohne dass jemand davor sitzt.
# Aufruf (braucht einen Bildschirm, z. B. den virtuellen Xvfb):
#   godot -s tools/screenshot.gd -- <ausgabe-ordner>
# Lässt die Figur ein Stück laufen und speichert dabei Bilder.
extends SceneTree

## Welche Tasten nacheinander wie viele Bilder lang gedrückt werden.
const SCHRITTE := [
	["", 30],
	["move_right", 40],
	["move_down", 40],
	["", 30],
]


func _initialize() -> void:
	var ordner: String = OS.get_cmdline_user_args()[0] if OS.get_cmdline_user_args().size() > 0 else "user://screenshots"
	DirAccess.make_dir_recursive_absolute(ordner)
	root.add_child(load("res://scenes/main/main.tscn").instantiate())
	_run.call_deferred(ordner)


func _run(ordner: String) -> void:
	var nummer := 0
	for schritt in SCHRITTE:
		var aktion: String = schritt[0]
		if aktion != "":
			Input.action_press(aktion)
		for i in schritt[1]:
			await process_frame
		if aktion != "":
			Input.action_release(aktion)
		await RenderingServer.frame_post_draw
		nummer += 1
		var pfad := ordner.path_join("bild_%d.png" % nummer)
		root.get_texture().get_image().save_png(pfad)
		print("gespeichert: ", pfad)
	quit()
