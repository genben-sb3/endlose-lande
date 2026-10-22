# Lade-Test: Jedes Skript im Projekt muss sich laden lassen.
# GUT überspringt Testdateien mit Tippfehlern sonst still – dieser Test
# sorgt dafür, dass der Testlauf dann rot wird (Exit-Code ≠ 0).
extends GutTest

const ORDNER := ["res://scenes", "res://test"]


func test_alle_skripte_lassen_sich_laden() -> void:
	var skripte := []
	for ordner in ORDNER:
		_sammle_skripte(ordner, skripte)
	assert_gt(skripte.size(), 0, "Skripte gefunden")
	for pfad in skripte:
		var skript: Script = load(pfad)
		assert_true(skript != null and skript.can_instantiate(), "%s lässt sich laden" % pfad)


func _sammle_skripte(ordner: String, skripte: Array) -> void:
	for datei in DirAccess.get_files_at(ordner):
		if datei.ends_with(".gd"):
			skripte.append(ordner.path_join(datei))
	for unterordner in DirAccess.get_directories_at(ordner):
		_sammle_skripte(ordner.path_join(unterordner), skripte)
