# PROTOTYP – speichert ein Bild vom Stil-Prototyp. Aufruf über bilder.sh.
extends SceneTree


func _initialize() -> void:
	root.add_child(load("res://prototypes/stil/stil_prototyp.tscn").instantiate())
	_save.call_deferred()


func _save() -> void:
	for i in 3:
		await process_frame
	await RenderingServer.frame_post_draw
	var args := OS.get_cmdline_user_args()
	root.get_texture().get_image().save_png(args[args.size() - 1])
	quit()
