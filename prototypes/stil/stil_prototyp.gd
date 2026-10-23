# PROTOTYP – Wegwerf-Code! Beantwortet nur die Frage: „Welcher Zeichenstil gefällt uns?"
# Starten:   godot prototypes/stil/stil_prototyp.tscn     (Tasten 1/2/3 = Stil, L = Nacht mit Fackel)
# Bilder:    prototypes/stil/bilder.sh
extends Node2D

## Die drei Stile, die wir vergleichen.
const STILE := {
	1: { "name": "A – Tusche & Cel", "linie": 2.5, "wackeln": 1.6, "stufen": 3, "weich": false },
	2: { "name": "B – Comic kräftig", "linie": 4.5, "wackeln": 0.6, "stufen": 2, "weich": false },
	3: { "name": "C – Gemalt weich", "linie": 0.0, "wackeln": 2.2, "stufen": 3, "weich": true },
}
const TUSCHE := Color("#2a2320")
## Licht kommt von oben links → Schatten fallen nach unten rechts.
const SCHATTEN_RICHTUNG := Vector2(14, 9)

## Felsfarben: Licht, Mitte, Schatten (grau und rötlich wie im Vorbild)
const FELS_GRAU := [Color("#d9d6cc"), Color("#a9a59b"), Color("#6f6c69")]
const FELS_ROT := [Color("#e3a27a"), Color("#c0714f"), Color("#7e4536")]
const LAUB := [Color("#9ccf5a"), Color("#5e9f3c"), Color("#2f6431")]
const STAMM := [Color("#a57650"), Color("#7a5236"), Color("#4b3222")]
const GRAS := [Color("#a7cf72"), Color("#8dbd5e"), Color("#6e9d4a")]
const ERDE := [Color("#e2cf98"), Color("#cdb47a"), Color("#a48d5c")]

var stil := 1
var nacht := false
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("stil="):
			stil = int(arg.substr(5))
		if arg == "nacht":
			nacht = true
	_update_licht()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode in [KEY_1, KEY_2, KEY_3]:
			stil = event.keycode - KEY_0
		elif event.keycode == KEY_L:
			nacht = not nacht
		_update_licht()
		queue_redraw()


func _update_licht() -> void:
	$Nacht.visible = nacht
	$Fackel.visible = nacht
	$UI/Name.text = STILE[stil].name + ("   (Nacht)" if nacht else "") + "      [1/2/3 = Stil, L = Licht]"


# ---- Szene ---------------------------------------------------------------------

func _draw() -> void:
	_rng.seed = 7  # gleiche Formen in jedem Stil, damit man vergleichen kann
	var s: Dictionary = STILE[stil]
	draw_rect(Rect2(0, 0, 1280, 720), Color("#9fa39b"))  # Hintergrund wie ein Skizzenblatt

	# Graswiese mit Erdweg
	_flaeche(_blob(Vector2(640, 420), Vector2(600, 270), 26), GRAS, s, 0.0)
	_flaeche(_blob(Vector2(560, 470), Vector2(230, 60), 18), ERDE, s, 0.0)

	# Große Felsstufe mit Höhe (links), kleine Brocken, rötlicher Fels (rechts)
	_felsstufe(Vector2(300, 380), Vector2(170, 70), 150, FELS_GRAU, s)
	_fels(Vector2(470, 300), 34, 30, FELS_GRAU, s)
	_fels(Vector2(520, 330), 20, 16, FELS_GRAU, s)
	_felsstufe(Vector2(960, 360), Vector2(120, 55), 110, FELS_ROT, s)
	_fels(Vector2(1080, 440), 26, 22, FELS_ROT, s)
	_fels(Vector2(720, 560), 30, 24, FELS_GRAU, s)

	# Bäume
	_baum(Vector2(640, 250), 1.0, s)
	_baum(Vector2(820, 300), 0.8, s)
	_baum(Vector2(180, 540), 0.9, s)

	# Die Spielfigur
	_figur(Vector2(600, 420), s)


# ---- Bausteine -----------------------------------------------------------------

## Eine unregelmäßige, rundliche Form (wie mit der Hand gezeichnet).
func _blob(mitte: Vector2, radien: Vector2, ecken: int) -> PackedVector2Array:
	var punkte := PackedVector2Array()
	for i in ecken:
		var w := TAU * i / ecken
		var r := 1.0 + _rng.randf_range(-0.08, 0.08)
		punkte.append(mitte + Vector2(cos(w) * radien.x, sin(w) * radien.y) * r)
	return punkte


## Kantige Felsform: wenige Ecken, kräftig verschoben.
func _kantig(mitte: Vector2, radien: Vector2, ecken: int) -> PackedVector2Array:
	var punkte := PackedVector2Array()
	for i in ecken:
		var w := TAU * i / ecken + _rng.randf_range(-0.15, 0.15)
		var r := 1.0 + _rng.randf_range(-0.18, 0.12)
		punkte.append(mitte + Vector2(cos(w) * radien.x, sin(w) * radien.y) * r)
	return punkte


## Lässt eine Linie leicht zittern, wie mit der Hand gezogen.
func _zittern(punkte: PackedVector2Array, staerke: float) -> PackedVector2Array:
	if staerke <= 0.0:
		return punkte
	# Kleine Formen zittern weniger, sonst überkreuzt sich der Umriss
	var ausdehnung := 0.0
	var m := _mitte(punkte)
	for p in punkte:
		ausdehnung = maxf(ausdehnung, p.distance_to(m))
	staerke = 0.0 if ausdehnung < 45.0 else minf(staerke, ausdehnung * 0.04)
	var neu := PackedVector2Array()
	for i in punkte.size():
		var a := punkte[i]
		var b := punkte[(i + 1) % punkte.size()]
		for t in 3:
			var p := a.lerp(b, t / 3.0)
			neu.append(p + Vector2(_rng.randf_range(-1, 1), _rng.randf_range(-1, 1)) * staerke)
	return neu


## Eine Fläche mit Schattierung: unten rechts Schatten, oben links Licht, dann der Umriss.
func _flaeche(form: PackedVector2Array, farben: Array, s: Dictionary, schlagschatten: float) -> void:
	form = _zittern(form, s.wackeln)
	var mitte := _mitte(form)
	if schlagschatten > 0.0:
		draw_colored_polygon(_verschieben(form, SCHATTEN_RICHTUNG * schlagschatten), Color(0.1, 0.12, 0.1, 0.25))
	if s.weich:
		# Gemalt: viele leicht versetzte, halb durchsichtige Schichten
		draw_colored_polygon(form, farben[1])
		for i in 6:
			var t := i / 6.0
			var c: Color = farben[2].lerp(farben[1], t)
			c.a = 0.22
			draw_colored_polygon(_skalieren(form, mitte + Vector2(8, 8), 1.0 - t * 0.15), c)
		for i in 5:
			var c: Color = farben[0]
			c.a = 0.18
			draw_colored_polygon(_skalieren(form, mitte - Vector2(10, 10), 0.75 - i * 0.1), c)
	else:
		draw_colored_polygon(form, farben[2])
		draw_colored_polygon(_skalieren(form, mitte - Vector2(4, 4), 0.86), farben[1])
		if s.stufen >= 3:
			draw_colored_polygon(_skalieren(form, mitte - Vector2(12, 12), 0.5), farben[0])
	if s.linie > 0.0:
		draw_polyline(form + PackedVector2Array([form[0]]), TUSCHE, s.linie, true)


## Ein Felsbrocken mit Höhe: die kantige Oberseite wird nach unten „herausgezogen".
## Jede sichtbare Seitenwand bekommt ihre Helligkeit danach, wie sehr sie zum Licht (links) zeigt.
func _fels(fuss: Vector2, breite: float, hoehe: float, farben: Array, s: Dictionary) -> void:
	var oben := _kantig(fuss - Vector2(0, hoehe), Vector2(breite, breite * 0.5), 8)
	oben = _zittern(oben, s.wackeln)
	var unten := _verschieben(oben, Vector2(0, hoehe))
	_schatten(_huelle(oben + unten), s)
	var n := oben.size()
	for i in n:
		var a := oben[i]
		var b := oben[(i + 1) % n]
		# Nur Wände, deren Außenseite nach unten (zu uns) zeigt, sind sichtbar
		var aussen := Vector2(b.y - a.y, a.x - b.x).normalized()
		if aussen.y <= 0.05:
			continue
		var wand := PackedVector2Array([a, b, b + Vector2(0, hoehe), a + Vector2(0, hoehe)])
		var licht := clampf(-aussen.x * 0.5 + 0.5, 0.0, 1.0)  # 1 = zeigt nach links zum Licht
		var farbe: Color
		if s.weich:
			farbe = farben[2].lerp(farben[1], licht)
		else:
			farbe = farben[1] if licht > 0.55 else farben[2]
		draw_colored_polygon(wand, farbe)
		if s.linie > 0.0:
			draw_polyline(wand + PackedVector2Array([wand[0]]), TUSCHE, s.linie * 0.7, true)
			if _rng.randf() < 0.5:  # ein Riss in der Wand
				var start := a.lerp(b, 0.5) + Vector2(0, hoehe * 0.15)
				draw_line(start, start + Vector2(_rng.randf_range(-4, 4), hoehe * 0.5), TUSCHE, s.linie * 0.5, true)
	_flaeche(oben, farben, s, 0.0)


## Eine große Felsstufe: mehrere Brocken übereinander, mit Grasbüscheln oben.
func _felsstufe(fuss: Vector2, groesse: Vector2, hoehe: float, farben: Array, s: Dictionary) -> void:
	var schichten := 3
	for i in schichten:
		var t := float(i) / schichten
		var f := fuss + Vector2(_rng.randf_range(-10, 10), -hoehe * t)
		_fels(f, groesse.x * (1.0 - t * 0.35), hoehe / schichten + 10, farben, s)
	# Gras auf der Spitze
	var spitze := fuss + Vector2(0, -hoehe - 14)
	_flaeche(_blob(spitze, Vector2(groesse.x * 0.4, 12), 12), GRAS, s, 0.0)


## Ein Baum: Stamm und eine Krone aus mehreren Laub-Wolken.
func _baum(fuss: Vector2, g: float, s: Dictionary) -> void:
	draw_colored_polygon(_blob(fuss + SCHATTEN_RICHTUNG * 2.5 * g, Vector2(70, 26) * g, 18), Color(0.1, 0.12, 0.1, 0.25))
	_flaeche(PackedVector2Array([fuss + Vector2(-9, 0) * g, fuss + Vector2(9, 0) * g,
		fuss + Vector2(6, -60) * g, fuss + Vector2(-6, -60) * g]), STAMM, s, 0.0)
	var wolken := [Vector2(-38, -80), Vector2(36, -82), Vector2(0, -112), Vector2(-20, -60), Vector2(24, -58)]
	for w in wolken:
		_flaeche(_blob(fuss + w * g, Vector2(40, 34) * g, 16), LAUB, s, 0.0)


## Die Spielfigur im gleichen Stil.
func _figur(fuss: Vector2, s: Dictionary) -> void:
	draw_colored_polygon(_blob(fuss + Vector2(10, 4), Vector2(22, 8), 14), Color(0.1, 0.12, 0.1, 0.3))
	_flaeche(_blob(fuss + Vector2(0, -20), Vector2(17, 20), 14), [Color("#7fb5ff"), Color("#4a8fe7"), Color("#2c5fa8")], s, 0.0)
	_flaeche(_blob(fuss + Vector2(0, -52), Vector2(16, 15), 14), [Color("#ffe6c9"), Color("#ffd2a6"), Color("#e0a982")], s, 0.0)
	_flaeche(_blob(fuss + Vector2(-1, -62), Vector2(16, 8), 12), [Color("#a9714a"), Color("#7a4a2a"), Color("#4e2e1a")], s, 0.0)
	draw_circle(fuss + Vector2(-5, -51), 2.2, TUSCHE, true, -1.0, true)
	draw_circle(fuss + Vector2(5, -51), 2.2, TUSCHE, true, -1.0, true)


func _schatten(form: PackedVector2Array, _s: Dictionary) -> void:
	draw_colored_polygon(_verschieben(form, SCHATTEN_RICHTUNG), Color(0.1, 0.12, 0.1, 0.25))


# ---- Geometrie-Helfer ------------------------------------------------------------

func _mitte(punkte: PackedVector2Array) -> Vector2:
	var summe := Vector2.ZERO
	for p in punkte:
		summe += p
	return summe / punkte.size()


func _verschieben(punkte: PackedVector2Array, um: Vector2) -> PackedVector2Array:
	var neu := PackedVector2Array()
	for p in punkte:
		neu.append(p + um)
	return neu


func _skalieren(punkte: PackedVector2Array, um: Vector2, faktor: float) -> PackedVector2Array:
	var neu := PackedVector2Array()
	for p in punkte:
		neu.append(um + (p - um) * faktor)
	return neu


func _huelle(punkte: PackedVector2Array) -> PackedVector2Array:
	return Geometry2D.convex_hull(punkte).slice(0, -1)
