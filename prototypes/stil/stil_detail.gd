# PROTOTYP – Wegwerf-Code! Zweite Runde: „Tusche & Cel" ohne Wackeln, mit mehr Details.
# Starten:  godot prototypes/stil/stil_detail.tscn   (L = Nacht mit Fackel)
# Bilder:   prototypes/stil/bilder.sh
extends Node2D

const TUSCHE := Color("#2b2421")
const LINIE := 2.2
## Licht kommt von oben links → Schatten fallen nach unten rechts.
const SCHATTEN := Vector2(16, 10)
const SCHATTEN_FARBE := Color(0.12, 0.16, 0.1, 0.28)

## Farbstufen: [Glanz, Licht, Mitte, Schatten]
const FELS_GRAU := [Color("#ecebe4"), Color("#cfccc2"), Color("#a19d94"), Color("#6c6964")]
const FELS_ROT := [Color("#f2bf98"), Color("#df9a6e"), Color("#b86c4b"), Color("#7a4434")]
const LAUB := [Color("#c4e57a"), Color("#8cc653"), Color("#5b9a3b"), Color("#2f6431")]
const MOOS := [Color("#c4e57a"), Color("#9ccf5a"), Color("#6aa544"), Color("#3f7a35")]
const STAMM := [Color("#c49a6c"), Color("#9c7048"), Color("#74502f"), Color("#4b3222")]
const GRAS := [Color("#b9dc84"), Color("#a3cf6f"), Color("#8cbd5c"), Color("#6f9e48")]
const ERDE := [Color("#efdfaa"), Color("#e0c98f"), Color("#c9ad72"), Color("#a08853")]
const BLUMEN := [Color("#ffffff"), Color("#ffe066"), Color("#ff9fbd"), Color("#c3a3ff")]

var nacht := false
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	nacht = "nacht" in OS.get_cmdline_user_args()
	_update_licht()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_L:
		nacht = not nacht
		_update_licht()


func _update_licht() -> void:
	$Nacht.visible = nacht
	$Fackel.visible = nacht
	$UI/Name.text = "D – Tusche & Cel, detailliert" + ("   (Nacht)" if nacht else "") + "      [L = Licht]"


# ---- Szene ---------------------------------------------------------------------

func _draw() -> void:
	_rng.seed = 11
	draw_rect(Rect2(0, 0, 1280, 720), Color("#9fa39b"))
	_wiese(_glatt(_rund(Vector2(640, 420), Vector2(610, 275), 22), 2))
	_weg(_glatt(_rund(Vector2(600, 500), Vector2(250, 62), 14), 2))

	# Von hinten nach vorne zeichnen, damit sich alles richtig überdeckt
	_baum(Vector2(660, 250), 1.05)
	_felsstufe(Vector2(300, 400), 165, [70, 55, 45], FELS_GRAU)
	_fels(Vector2(470, 315), 36, 30, FELS_GRAU, true)
	_fels(Vector2(522, 338), 20, 15, FELS_GRAU, false)
	_baum(Vector2(840, 310), 0.85)
	_felsstufe(Vector2(985, 395), 120, [55, 45], FELS_ROT)
	_fels(Vector2(1090, 455), 28, 22, FELS_ROT, true)
	if nacht:
		_fackel(Vector2(545, 445))
	_figur(Vector2(600, 440))
	_baum(Vector2(175, 560), 0.95)
	_fels(Vector2(745, 585), 32, 24, FELS_GRAU, true)


# ---- Boden ---------------------------------------------------------------------

func _wiese(form: PackedVector2Array) -> void:
	_mit_umriss(form, GRAS[2])
	# große weiche Flecken für Abwechslung
	for i in 14:
		var p := Vector2(_rng.randf_range(120, 1160), _rng.randf_range(200, 640))
		var c: Color = GRAS[0] if i % 2 == 0 else GRAS[3]
		c.a = 0.16
		if Geometry2D.is_point_in_polygon(p, form):
			draw_colored_polygon(_rund(p, Vector2(110, 50) * _rng.randf_range(0.6, 1.2), 20), c)
	# Grasbüschel und Blümchen
	for i in 160:
		var p := Vector2(_rng.randf_range(60, 1220), _rng.randf_range(170, 680))
		if Geometry2D.is_point_in_polygon(p, Geometry2D.offset_polygon(form, -12)[0]):
			if i % 9 == 0:
				_bluemchen(p)
			else:
				_bueschel(p, 1.0)


func _weg(form: PackedVector2Array) -> void:
	_mit_umriss(form, ERDE[2])
	draw_colored_polygon(_skalieren(form, _mitte(form) + Vector2(-10, -6), 0.85), ERDE[1])
	draw_colored_polygon(_skalieren(form, _mitte(form) + Vector2(-30, -14), 0.55), ERDE[0])
	for i in 14:  # Kiesel
		var p := _mitte(form) + Vector2(_rng.randf_range(-220, 220), _rng.randf_range(-40, 40))
		if Geometry2D.is_point_in_polygon(p, form):
			_kiesel(p, _rng.randf_range(2.5, 5.0))


func _bueschel(p: Vector2, g: float) -> void:
	var halme := _rng.randi_range(3, 5)
	for h in halme:
		var x := (h - halme / 2.0) * 2.6 * g
		var spitze := p + Vector2(x * 1.8 + _rng.randf_range(-2, 2), -_rng.randf_range(7, 12) * g)
		var c: Color = GRAS[3] if h % 2 == 0 else GRAS[0]
		draw_polyline(PackedVector2Array([p + Vector2(x, 0), p + Vector2(x * 1.3, -4 * g), spitze]), c, 1.6, true)


func _bluemchen(p: Vector2) -> void:
	var c: Color = BLUMEN[_rng.randi() % BLUMEN.size()]
	for b in 5:
		var q := p + Vector2.from_angle(TAU * b / 5.0) * 3.2
		draw_circle(q, 2.8, TUSCHE, true, -1.0, true)
	for b in 5:
		draw_circle(p + Vector2.from_angle(TAU * b / 5.0) * 3.2, 2.0, c, true, -1.0, true)
	draw_circle(p, 1.8, Color("#ffb703"), true, -1.0, true)


func _kiesel(p: Vector2, r: float) -> void:
	var form := _rund(p, Vector2(r, r * 0.7), 10)
	_mit_umriss(form, FELS_GRAU[2], 1.4)
	draw_colored_polygon(_skalieren(form, p + Vector2(-r * 0.4, -r * 0.4), 0.6), FELS_GRAU[0])


# ---- Felsen --------------------------------------------------------------------

## Ein Felsbrocken mit Höhe: die Oberseite wird nach unten „herausgezogen".
## Die Wände bestehen aus mehreren senkrechten Flächen, die je nach Richtung
## heller (zum Licht links) oder dunkler sind.
func _fels(fuss: Vector2, breite: float, hoehe: float, farben: Array, mit_moos: bool) -> void:
	var oben := _felsform(fuss - Vector2(0, hoehe), breite)
	var unten := _verschieben(oben, Vector2(0, hoehe))
	var umriss := Geometry2D.convex_hull(oben + unten).slice(0, -1)
	# Schlagschatten und Umriss (einmal außen herum, dick)
	draw_colored_polygon(_verschieben(umriss, SCHATTEN * (0.4 + hoehe / 80.0)), SCHATTEN_FARBE)
	draw_colored_polygon(Geometry2D.offset_polygon(umriss, LINIE)[0], TUSCHE)
	_waende(oben, hoehe, farben)
	_oberseite(oben, farben, breite)
	if mit_moos:
		_moos(oben, breite)
	# Kiesel am Fuß
	for i in _rng.randi_range(1, 3):
		_kiesel(fuss + Vector2(_rng.randf_range(-breite, breite), _rng.randf_range(4, 10)), _rng.randf_range(2.5, 4.5))


## Eine große Felsstufe: mehrere Felsen übereinander, jeder kleiner als der darunter.
func _felsstufe(fuss: Vector2, breite: float, hoehen: Array, farben: Array) -> void:
	var y := 0.0
	for i in hoehen.size():
		var h: float = hoehen[i]
		var b := breite * (1.0 - i * 0.22)
		_fels(fuss + Vector2(_rng.randf_range(-12, 12), -y), b, h, farben, i == hoehen.size() - 1)
		y += h - b * 0.12


func _felsform(mitte: Vector2, breite: float) -> PackedVector2Array:
	var punkte := PackedVector2Array()
	var ecken := 7
	for i in ecken:
		var w := TAU * i / ecken + _rng.randf_range(-0.2, 0.2)
		var r := _rng.randf_range(0.72, 1.0)
		punkte.append(mitte + Vector2(cos(w) * breite, sin(w) * breite * 0.5) * r)
	return punkte


func _waende(oben: PackedVector2Array, hoehe: float, farben: Array) -> void:
	var n := oben.size()
	for i in n:
		var a := oben[i]
		var b := oben[(i + 1) % n]
		var aussen := Vector2(b.y - a.y, a.x - b.x).normalized()
		if aussen.y <= 0.0:
			continue  # Wand zeigt nach hinten – nicht sichtbar
		var licht := clampf(-aussen.x * 0.6 + 0.5, 0.0, 1.0)
		# jede Wand in 1–3 senkrechte Flächen teilen
		var teile := clampi(int(a.distance_to(b) / 16.0), 1, 3)
		for t in teile:
			var p := a.lerp(b, float(t) / teile)
			var q := a.lerp(b, float(t + 1) / teile)
			var dunkel := licht + _rng.randf_range(-0.15, 0.15)
			var farbe: Color = farben[1] if dunkel > 0.7 else (farben[2] if dunkel > 0.38 else farben[3])
			var flaeche := PackedVector2Array([p, q, q + Vector2(0, hoehe * _rng.randf_range(0.9, 1.06)), p + Vector2(0, hoehe * _rng.randf_range(0.9, 1.06))])
			draw_colored_polygon(flaeche, farbe)
			# helle Kante links an jeder Fläche, dünne Tusche-Linie dazwischen
			draw_line(p + Vector2(1.2, 1), p + Vector2(1.2, hoehe - 1), farben[0].lerp(farbe, 0.5), 1.4, true)
			if t > 0 or i > 0:
				draw_line(p, p + Vector2(0, hoehe), TUSCHE, 1.1, true)
		# Riss in manchen Wänden
		if _rng.randf() < 0.45 and hoehe > 18:
			var s := a.lerp(b, _rng.randf_range(0.3, 0.7)) + Vector2(0, hoehe * 0.2)
			var riss := PackedVector2Array([s, s + Vector2(3, hoehe * 0.25), s + Vector2(-1, hoehe * 0.5)])
			draw_polyline(_verschieben(riss, Vector2(1.2, 0.8)), farben[1], 1.2, true)
			draw_polyline(riss, TUSCHE, 1.3, true)
	# Dunkler Übergang am Boden (dort kommt wenig Licht hin)
	for i in n:
		var a := oben[i]
		var b := oben[(i + 1) % n]
		if Vector2(b.y - a.y, a.x - b.x).y > 0.0:
			var c := Color(0.08, 0.06, 0.05, 0.22)
			draw_colored_polygon(PackedVector2Array([a + Vector2(0, hoehe - 7), b + Vector2(0, hoehe - 7),
				b + Vector2(0, hoehe), a + Vector2(0, hoehe)]), c)


func _oberseite(oben: PackedVector2Array, farben: Array, breite: float) -> void:
	# Die Oberseite besteht aus schrägen Platten (Dreiecke von einem Punkt in der Mitte aus).
	# Platten, die nach oben links zum Licht zeigen, sind heller.
	var m := _mitte(oben) + Vector2(_rng.randf_range(-0.15, 0.15), _rng.randf_range(-0.1, 0.1)) * breite
	var n := oben.size()
	for i in n:
		var a := oben[i]
		var b := oben[(i + 1) % n]
		var richtung := ((a + b) / 2.0 - m).normalized()
		var licht := -richtung.x * 0.6 - richtung.y * 0.6
		var farbe: Color = farben[0] if licht > 0.35 else (farben[1] if licht > -0.3 else farben[2].lerp(farben[1], 0.5))
		draw_colored_polygon(PackedVector2Array([m, a, b]), farbe)
	# feine Kanten zwischen den Platten
	for i in n:
		if i % 2 == 0:
			draw_line(m, oben[i], farben[3].lerp(farben[2], 0.4), 1.0, true)
	draw_polyline(oben + PackedVector2Array([oben[0]]), TUSCHE, 1.6, true)
	# ein feiner Riss mit hellem Rand
	var s := m + Vector2(_rng.randf_range(-breite * 0.4, 0), _rng.randf_range(-3, 3))
	var riss := PackedVector2Array([s, s + Vector2(breite * 0.15, 3), s + Vector2(breite * 0.3, -1)])
	draw_polyline(_verschieben(riss, Vector2(0, 1.2)), farben[0], 1.2, true)
	draw_polyline(riss, farben[3], 1.2, true)


func _moos(oben: PackedVector2Array, breite: float) -> void:
	var m := _mitte(oben)
	var flecken := []
	for i in 3:
		flecken.append([m + Vector2(_rng.randf_range(-breite * 0.5, breite * 0.4), _rng.randf_range(-breite * 0.2, breite * 0.1)),
			_rng.randf_range(breite * 0.07, breite * 0.14)])
	for f in flecken:
		draw_colored_polygon(_rund(f[0], Vector2(f[1] + 2, f[1] * 0.6 + 2), 14), TUSCHE)
	for f in flecken:
		draw_colored_polygon(_rund(f[0], Vector2(f[1], f[1] * 0.6), 14), MOOS[2])
		draw_colored_polygon(_rund(f[0] + Vector2(-f[1] * 0.25, -f[1] * 0.15), Vector2(f[1] * 0.6, f[1] * 0.35), 12), MOOS[1])
	for f in flecken:
		_bueschel(f[0] + Vector2(0, f[1] * 0.2), 0.9)


# ---- Bäume ---------------------------------------------------------------------

## Ein Baum: Stamm mit Wurzeln und eine Krone aus vielen Laub-Büscheln.
## Die Krone hat nur außen herum einen Umriss; hinten ist sie dunkel, oben links hell.
func _baum(fuss: Vector2, g: float) -> void:
	draw_colored_polygon(_rund(fuss + SCHATTEN * 2.2 * g, Vector2(78, 28) * g, 22), SCHATTEN_FARBE)
	# Stamm
	var stamm := PackedVector2Array([fuss + Vector2(-16, 2) * g, fuss + Vector2(-8, -4) * g, fuss + Vector2(-6, -62) * g,
		fuss + Vector2(6, -62) * g, fuss + Vector2(8, -4) * g, fuss + Vector2(17, 3) * g, fuss + Vector2(0, 0) * g])
	_mit_umriss(stamm, STAMM[2])
	draw_colored_polygon(PackedVector2Array([fuss + Vector2(-6, -4) * g, fuss + Vector2(-4, -60) * g,
		fuss + Vector2(0, -60) * g, fuss + Vector2(-1, -4) * g]), STAMM[1])
	for i in 3:
		var y := -14.0 - i * 15.0
		draw_line(fuss + Vector2(2, y) * g, fuss + Vector2(4, y - 7) * g, STAMM[3], 1.2, true)
	# Laub-Büschel in einer Kuppel
	var bueschel := []
	for i in 16:
		var w := _rng.randf_range(PI * 1.05, PI * 1.95)
		var r := _rng.randf_range(0.2, 1.0)
		var p := fuss + Vector2(cos(w) * 52 * r, -95 + sin(w) * 40 * r + 30) * g
		bueschel.append([p, _rng.randf_range(20, 30) * g])
	bueschel.sort_custom(func(a, b): return a[0].y < b[0].y)
	for b in bueschel:  # Umriss der ganzen Krone
		draw_circle(b[0], b[1] + LINIE, TUSCHE, true, -1.0, true)
	for b in bueschel:  # dunkle Grundfarbe
		draw_circle(b[0], b[1], LAUB[3], true, -1.0, true)
	for b in bueschel:  # jedes Büschel oben links heller
		draw_circle(b[0] + Vector2(-b[1] * 0.2, -b[1] * 0.25), b[1] * 0.78, LAUB[2], true, -1.0, true)
	for b in bueschel:
		var oben_links: bool = (b[0].x - fuss.x) / g < 15 and (b[0].y - fuss.y) / g < -80
		if oben_links:
			draw_circle(b[0] + Vector2(-b[1] * 0.3, -b[1] * 0.35), b[1] * 0.45, LAUB[1], true, -1.0, true)
	for i in 26:  # Lichtpunkte auf den Blättern
		var b: Array = bueschel[_rng.randi() % bueschel.size()]
		var p: Vector2 = b[0] + Vector2(_rng.randf_range(-0.6, 0.2), _rng.randf_range(-0.6, 0.1)) * b[1]
		draw_circle(p, _rng.randf_range(1.5, 3.0) * g, LAUB[0], true, -1.0, true)


# ---- Figur und Fackel ------------------------------------------------------------

func _figur(fuss: Vector2) -> void:
	draw_colored_polygon(_rund(fuss + Vector2(10, 3), Vector2(22, 8), 16), SCHATTEN_FARBE)
	var koerper := _rund(fuss + Vector2(0, -20), Vector2(17, 20), 20)
	var kopf := _rund(fuss + Vector2(0, -52), Vector2(16, 15), 20)
	var haare := _rund(fuss + Vector2(-1, -61), Vector2(17, 9), 18)
	for f in [koerper, kopf, haare]:  # ein Umriss um die ganze Figur
		draw_colored_polygon(Geometry2D.offset_polygon(f, LINIE)[0], TUSCHE)
	_schattiert(koerper, [Color("#a6ccff"), Color("#6fa6f0"), Color("#4a8fe7"), Color("#2c5fa8")])
	_schattiert(kopf, [Color("#fff1de"), Color("#ffe2c4"), Color("#ffd2a6"), Color("#e0a982")])
	_schattiert(haare, [Color("#c48a5c"), Color("#a9714a"), Color("#7a4a2a"), Color("#4e2e1a")])
	for x in [-5, 5]:
		draw_circle(fuss + Vector2(x, -50), 2.6, TUSCHE, true, -1.0, true)
		draw_circle(fuss + Vector2(x - 0.8, -51), 0.9, Color.WHITE, true, -1.0, true)
	draw_circle(fuss + Vector2(-9, -45), 2.5, Color(1, 0.5, 0.5, 0.35), true, -1.0, true)  # Bäckchen
	draw_circle(fuss + Vector2(9, -45), 2.5, Color(1, 0.5, 0.5, 0.35), true, -1.0, true)


func _fackel(fuss: Vector2) -> void:
	_mit_umriss(PackedVector2Array([fuss + Vector2(-2.5, 0), fuss + Vector2(2.5, 0), fuss + Vector2(3, -34), fuss + Vector2(-3, -34)]), STAMM[2])
	var flamme := [[Color("#ff7b2e"), 9.0], [Color("#ffb347"), 6.5], [Color("#fff1a8"), 3.5]]
	for f in flamme:
		var r: float = f[1]
		draw_colored_polygon(PackedVector2Array([fuss + Vector2(-r, -36), fuss + Vector2(0, -36 - r * 2.8), fuss + Vector2(r, -36),
			fuss + Vector2(r * 0.6, -36 + r * 0.6), fuss + Vector2(-r * 0.6, -36 + r * 0.6)]), f[0])


# ---- Helfer ----------------------------------------------------------------------

## Füllt eine Form und zeichnet einen sauberen Tusche-Umriss außen herum.
func _mit_umriss(form: PackedVector2Array, farbe: Color, linie := LINIE) -> void:
	draw_colored_polygon(Geometry2D.offset_polygon(form, linie)[0], TUSCHE)
	draw_colored_polygon(form, farbe)


## Füllt eine Form mit Licht oben links und Schatten unten rechts (Cel-Shading).
func _schattiert(form: PackedVector2Array, farben: Array) -> void:
	var m := _mitte(form)
	draw_colored_polygon(form, farben[3])
	draw_colored_polygon(_skalieren(form, m + Vector2(-5, -5), 0.88), farben[2])
	draw_colored_polygon(_skalieren(form, m + Vector2(-9, -9), 0.6), farben[1])
	draw_colored_polygon(_skalieren(form, m + Vector2(-9, -10), 0.25), farben[0])


func _rund(mitte: Vector2, radien: Vector2, ecken: int) -> PackedVector2Array:
	var punkte := PackedVector2Array()
	for i in ecken:
		var w := TAU * i / ecken
		punkte.append(mitte + Vector2(cos(w) * radien.x, sin(w) * radien.y) * _rng.randf_range(0.94, 1.0))
	return punkte


## Rundet Ecken ab (Chaikin): aus jeder Ecke werden zwei Punkte.
func _glatt(punkte: PackedVector2Array, runden: int) -> PackedVector2Array:
	for r in runden:
		var neu := PackedVector2Array()
		for i in punkte.size():
			var a := punkte[i]
			var b := punkte[(i + 1) % punkte.size()]
			neu.append(a.lerp(b, 0.22))
			neu.append(a.lerp(b, 0.78))
		punkte = neu
	return punkte


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
