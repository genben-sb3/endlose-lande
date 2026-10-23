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
const SCHNEE := [Color("#ffffff"), Color("#eef3f8"), Color("#cdd9e6"), Color("#9fb0c4")]
const TANNE := [Color("#7fb86a"), Color("#4f8f4c"), Color("#2f6a3e"), Color("#1d4630")]
const WASSER := [Color("#bfeaf5"), Color("#79c9e4"), Color("#4aa3cf"), Color("#2f73a6")]
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
	_boden()
	_weg(PackedVector2Array([Vector2(-40, 690), Vector2(260, 610), Vector2(520, 560), Vector2(700, 470),
		Vector2(860, 420), Vector2(1100, 400), Vector2(1320, 360)]))
	_teich(Vector2(1010, 600), Vector2(190, 70))

	# Alle Dinge sammeln und von hinten (oben) nach vorne (unten) zeichnen,
	# damit sich alles richtig überdeckt.
	var dinge := []
	dinge.append([150, _klippe.bind(Vector2(330, 250), 250, [90, 80, 70], true)])
	dinge.append([140, _klippe.bind(Vector2(80, 210), 130, [70, 60], true)])
	for x in range(560, 1300, 62):  # Waldrand hinten
		var y := 150.0 + _rng.randf_range(-30, 25)
		dinge.append([y, (_tanne if _rng.randf() < 0.45 else _baum).bind(Vector2(x + _rng.randf_range(-15, 15), y), _rng.randf_range(0.8, 1.15))])
	for x in range(600, 1300, 85):  # zweite Reihe, etwas weiter vorne
		var y := 235.0 + _rng.randf_range(-20, 20)
		dinge.append([y, (_baum if _rng.randf() < 0.6 else _tanne).bind(Vector2(x + _rng.randf_range(-20, 20), y), _rng.randf_range(0.75, 1.0))])
	dinge.append([330, _fels.bind(Vector2(520, 330), 36, 30, FELS_GRAU, true)])
	dinge.append([355, _fels.bind(Vector2(575, 355), 20, 15, FELS_GRAU, false)])
	dinge.append([520, _fels.bind(Vector2(180, 520), 46, 34, FELS_GRAU, true)])
	dinge.append([470, _felsstufe.bind(Vector2(1180, 470), 80, [45, 35], FELS_ROT)])
	dinge.append([400, _stamm_liegend.bind(Vector2(430, 410))])
	for b in [Vector2(640, 300), Vector2(90, 420), Vector2(300, 470), Vector2(760, 640), Vector2(1240, 560), Vector2(880, 300)]:
		dinge.append([b.y, _busch.bind(b, _rng.randf_range(0.7, 1.0))])
	for p in [Vector2(470, 440), Vector2(490, 450), Vector2(380, 440), Vector2(230, 540)]:
		dinge.append([p.y, _pilz.bind(p)])
	dinge.append([470, _figur.bind(Vector2(640, 470))])
	if nacht:
		dinge.append([470, _fackel.bind(Vector2(590, 470))])
	for x in range(-20, 1300, 70):  # hohes Gras ganz vorne
		dinge.append([715, _hohes_gras.bind(Vector2(x + _rng.randf_range(-20, 20), 718))])
	dinge.sort_custom(func(a, b): return a[0] < b[0])
	for d in dinge:
		d[1].call()


# ---- Boden ---------------------------------------------------------------------

func _boden() -> void:
	draw_rect(Rect2(0, 0, 1280, 720), GRAS[2])
	# große weiche Flecken: hell im Licht, dunkler unter den Bäumen
	for i in 40:
		var p := Vector2(_rng.randf_range(0, 1280), _rng.randf_range(0, 720))
		var c: Color = GRAS[0] if p.y > 330 and _rng.randf() < 0.6 else GRAS[3]
		c.a = 0.18
		draw_colored_polygon(_rund(p, Vector2(140, 60) * _rng.randf_range(0.5, 1.3), 20), c)
	# Schatten des Waldes oben
	var schatten := Color(0.12, 0.25, 0.12, 0.35)
	draw_colored_polygon(PackedVector2Array([Vector2(520, 0), Vector2(1280, 0), Vector2(1280, 300), Vector2(900, 330), Vector2(560, 300)]), schatten)
	# Blumenwiese unten links
	for i in 70:
		_bluemchen(Vector2(_rng.randf_range(40, 520), _rng.randf_range(560, 700)))
	for i in 360:
		var p := Vector2(_rng.randf_range(0, 1280), _rng.randf_range(260, 720))
		if i % 25 == 0:
			_bluemchen(p)
		else:
			_bueschel(p, 1.0)


func _weg(linie: PackedVector2Array) -> void:
	var breit := Geometry2D.offset_polyline(_glatt_offen(linie, 3), 34, Geometry2D.JOIN_ROUND, Geometry2D.END_ROUND)
	var schmal := Geometry2D.offset_polyline(_glatt_offen(linie, 3), 22, Geometry2D.JOIN_ROUND, Geometry2D.END_ROUND)
	for f in breit:
		_mit_umriss(f, ERDE[2])
	for f in schmal:
		draw_colored_polygon(_verschieben(f, Vector2(-3, -3)), ERDE[1])
	for i in 50:  # Kiesel und Spuren
		var t := _rng.randf()
		var idx := int(t * (linie.size() - 1))
		var p := linie[idx].lerp(linie[idx + 1], _rng.randf()) + Vector2(_rng.randf_range(-22, 22), _rng.randf_range(-14, 14))
		_kiesel(p, _rng.randf_range(2.0, 4.5))


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
	_laub(bueschel, fuss, g, -80)


## Eine Laub-Krone aus Büscheln [Mitte, Radius]: Umriss außen, hinten dunkel, oben links hell.
func _laub(bueschel: Array, fuss: Vector2, g: float, licht_hoehe: float) -> void:
	bueschel.sort_custom(func(a, b): return a[0].y < b[0].y)
	for b in bueschel:  # Umriss der ganzen Krone
		draw_circle(b[0], b[1] + LINIE, TUSCHE, true, -1.0, true)
	for b in bueschel:  # dunkle Grundfarbe
		draw_circle(b[0], b[1], LAUB[3], true, -1.0, true)
	for b in bueschel:  # jedes Büschel oben links heller
		draw_circle(b[0] + Vector2(-b[1] * 0.2, -b[1] * 0.25), b[1] * 0.78, LAUB[2], true, -1.0, true)
	for b in bueschel:
		var oben_links: bool = (b[0].x - fuss.x) / g < 15 and (b[0].y - fuss.y) / g < licht_hoehe
		if oben_links:
			draw_circle(b[0] + Vector2(-b[1] * 0.3, -b[1] * 0.35), b[1] * 0.45, LAUB[1], true, -1.0, true)
	for i in bueschel.size() * 2:  # Lichtpunkte auf den Blättern
		var b: Array = bueschel[_rng.randi() % bueschel.size()]
		var p: Vector2 = b[0] + Vector2(_rng.randf_range(-0.6, 0.2), _rng.randf_range(-0.6, 0.1)) * b[1]
		draw_circle(p, _rng.randf_range(1.5, 3.0) * g, LAUB[0], true, -1.0, true)


# ---- Felswand mit Schnee ------------------------------------------------------

## Eine hohe Felswand aus mehreren Stufen. Auf Wunsch liegt oben Schnee,
## der in Zungen die Wände hinunterläuft.
func _klippe(fuss: Vector2, breite: float, hoehen: Array, mit_schnee: bool) -> void:
	var y := 0.0
	for i in hoehen.size():
		var h: float = hoehen[i]
		var b := breite * (1.0 - i * 0.25)
		var f := fuss + Vector2(_rng.randf_range(-20, 20), -y)
		_fels(f, b, h, FELS_GRAU, false)
		if mit_schnee and i >= hoehen.size() - 2:
			_schnee(f - Vector2(0, h), b, h)
		y += h - b * 0.12


func _schnee(oben_mitte: Vector2, breite: float, hoehe: float) -> void:
	# Schneekappe: weiche Flecken auf der Oberseite
	var kappe := _rund(oben_mitte + Vector2(-breite * 0.1, -2), Vector2(breite * 0.75, breite * 0.33), 18)
	_mit_umriss(kappe, SCHNEE[1], 1.6)
	draw_colored_polygon(_skalieren(kappe, oben_mitte + Vector2(-breite * 0.4, -breite * 0.15), 0.6), SCHNEE[0])
	draw_colored_polygon(_skalieren(kappe, oben_mitte + Vector2(breite * 0.4, breite * 0.1), 0.35), SCHNEE[2])
	# Zungen, die die Wand hinunterlaufen
	for i in _rng.randi_range(4, 6):
		var x := _rng.randf_range(-breite * 0.7, breite * 0.6)
		var start := oben_mitte + Vector2(x, breite * 0.2)
		var laenge := _rng.randf_range(hoehe * 0.25, hoehe * 0.7)
		var zunge := PackedVector2Array([start + Vector2(-9, 0), start + Vector2(9, 0), start + Vector2(4, laenge * 0.6),
			start + Vector2(1, laenge), start + Vector2(-3, laenge * 0.7)])
		_mit_umriss(zunge, SCHNEE[2] if x > 0 else SCHNEE[1], 1.3)


# ---- Pflanzen ------------------------------------------------------------------

## Eine Tanne: mehrere Zacken-Stufen übereinander, links heller.
func _tanne(fuss: Vector2, g: float) -> void:
	draw_colored_polygon(_rund(fuss + SCHATTEN * 2.0 * g, Vector2(50, 18) * g, 18), SCHATTEN_FARBE)
	_mit_umriss(PackedVector2Array([fuss + Vector2(-5, 0) * g, fuss + Vector2(5, 0) * g,
		fuss + Vector2(4, -20) * g, fuss + Vector2(-4, -20) * g]), STAMM[2])
	var stufen := 4
	var formen := []
	for i in stufen:
		var y := -18.0 - i * 26.0
		var b := 42.0 - i * 9.0
		var spitze := y - 44.0
		var zacke := PackedVector2Array([fuss + Vector2(-b, y) * g, fuss + Vector2(-b * 0.5, y - 6) * g,
			fuss + Vector2(0, y + 2) * g, fuss + Vector2(b * 0.5, y - 6) * g, fuss + Vector2(b, y) * g, fuss + Vector2(0, spitze) * g])
		formen.append(zacke)
	for f in formen:
		draw_colored_polygon(Geometry2D.offset_polygon(f, LINIE)[0], TUSCHE)
	for f in formen:
		draw_colored_polygon(f, TANNE[2])
		# linke Hälfte im Licht
		var spitze: Vector2 = f[5]
		draw_colored_polygon(PackedVector2Array([f[0], f[1], f[2], spitze]), TANNE[1])
		draw_line(spitze, f[2], TANNE[3], 1.2, true)
		draw_colored_polygon(PackedVector2Array([f[0].lerp(spitze, 0.5), f[1].lerp(spitze, 0.55), spitze]), TANNE[0])


## Ein Busch: eine kleine Krone ohne Stamm, manchmal mit Beeren.
func _busch(fuss: Vector2, g: float) -> void:
	draw_colored_polygon(_rund(fuss + SCHATTEN * 1.2 * g, Vector2(40, 14) * g, 16), SCHATTEN_FARBE)
	var bueschel := []
	for i in 7:
		bueschel.append([fuss + Vector2(_rng.randf_range(-26, 26), _rng.randf_range(-30, -8)) * g, _rng.randf_range(13, 19) * g])
	_laub(bueschel, fuss, g, -20)
	if _rng.randf() < 0.5:
		for i in 6:
			var b: Array = bueschel[_rng.randi() % bueschel.size()]
			var p: Vector2 = b[0] + Vector2(_rng.randf_range(-0.5, 0.5), _rng.randf_range(-0.3, 0.5)) * b[1]
			draw_circle(p, 3.2, TUSCHE, true, -1.0, true)
			draw_circle(p, 2.3, Color("#e8475f"), true, -1.0, true)
			draw_circle(p + Vector2(-0.8, -0.8), 0.8, Color.WHITE, true, -1.0, true)


func _hohes_gras(fuss: Vector2) -> void:
	for h in 9:
		var x := (h - 4) * 4.0
		var hoehe := _rng.randf_range(22, 40)
		var spitze := fuss + Vector2(x * 1.6 + _rng.randf_range(-6, 6), -hoehe)
		var linie := PackedVector2Array([fuss + Vector2(x, 0), fuss + Vector2(x * 1.2, -hoehe * 0.5), spitze])
		draw_polyline(linie, TUSCHE, 3.4, true)
		draw_polyline(linie, GRAS[3] if h % 3 == 0 else GRAS[1], 2.0, true)


func _pilz(p: Vector2) -> void:
	_mit_umriss(PackedVector2Array([p + Vector2(-2.5, 0), p + Vector2(2.5, 0), p + Vector2(2, -7), p + Vector2(-2, -7)]), Color("#f4ead2"), 1.3)
	var hut := _rund(p + Vector2(0, -8), Vector2(7, 4.5), 14)
	_mit_umriss(hut, Color("#d8433b"), 1.4)
	draw_colored_polygon(_skalieren(hut, p + Vector2(-3, -10), 0.5), Color("#ef6a55"))
	for d in [Vector2(-3, -9), Vector2(2, -10), Vector2(4, -7)]:
		draw_circle(p + d, 1.1, Color.WHITE, true, -1.0, true)


## Ein umgestürzter Baumstamm mit Moos und Jahresringen.
func _stamm_liegend(p: Vector2) -> void:
	var laenge := 110.0
	draw_colored_polygon(_rund(p + Vector2(laenge * 0.5, 14), Vector2(laenge * 0.6, 10), 16), SCHATTEN_FARBE)
	var koerper := PackedVector2Array([p + Vector2(0, -12), p + Vector2(laenge, -14), p + Vector2(laenge, 12), p + Vector2(0, 12)])
	_mit_umriss(koerper, STAMM[2])
	draw_colored_polygon(PackedVector2Array([p + Vector2(0, -12), p + Vector2(laenge, -14), p + Vector2(laenge, -3), p + Vector2(0, -2)]), STAMM[1])
	for i in 5:
		var x := 18.0 + i * 20.0
		draw_line(p + Vector2(x, -6), p + Vector2(x + 12, -5), STAMM[3], 1.2, true)
	var ende := _rund(p + Vector2(laenge, -1), Vector2(8, 13), 16)
	_mit_umriss(ende, STAMM[0], 1.6)
	draw_arc(p + Vector2(laenge, -1), 6.0, 0, TAU, 16, STAMM[2], 1.0, true)
	draw_arc(p + Vector2(laenge, -1), 3.0, 0, TAU, 12, STAMM[2], 1.0, true)
	var moos := [[p + Vector2(30, -12), 10.0], [p + Vector2(48, -13), 8.0]]
	for m in moos:
		draw_colored_polygon(_rund(m[0], Vector2(m[1] + 1.5, m[1] * 0.5 + 1.5), 12), TUSCHE)
	for m in moos:
		draw_colored_polygon(_rund(m[0], Vector2(m[1], m[1] * 0.5), 12), MOOS[2])
		draw_colored_polygon(_rund(m[0] + Vector2(-2, -1), Vector2(m[1] * 0.6, m[1] * 0.3), 10), MOOS[1])


# ---- Teich ---------------------------------------------------------------------

func _teich(mitte: Vector2, radien: Vector2) -> void:
	var form := _glatt(_rund(mitte, radien, 16), 2)
	draw_colored_polygon(Geometry2D.offset_polygon(form, 10)[0], ERDE[1])  # Sand-Ufer
	_mit_umriss(form, WASSER[2])
	draw_colored_polygon(_skalieren(form, mitte + Vector2(20, 10), 0.7), WASSER[3])  # tiefere Mitte
	draw_colored_polygon(_skalieren(form, mitte + Vector2(-radien.x * 0.9, -radien.y * 0.9), 0.35), WASSER[1])
	for i in 7:  # Lichtspiegelungen
		var p := mitte + Vector2(_rng.randf_range(-0.6, 0.5) * radien.x, _rng.randf_range(-0.5, 0.4) * radien.y)
		draw_line(p, p + Vector2(_rng.randf_range(10, 26), 0), WASSER[0], 1.6, true)
	for i in 4:  # Seerosen
		var p := mitte + Vector2(_rng.randf_range(-0.6, 0.6) * radien.x, _rng.randf_range(-0.4, 0.5) * radien.y)
		var blatt := _rund(p, Vector2(10, 6), 14)
		_mit_umriss(blatt, MOOS[2], 1.3)
		draw_line(p, p + Vector2(9, -2), MOOS[3], 1.4, true)
		if i % 2 == 0:
			for b in 5:
				draw_circle(p + Vector2(-2, -3) + Vector2.from_angle(TAU * b / 5.0) * 2.4, 2.0, Color("#ffd1e0"), true, -1.0, true)
			draw_circle(p + Vector2(-2, -3), 1.4, Color("#ffd23f"), true, -1.0, true)
	# Schilf am Ufer
	for i in 7:
		var w := _rng.randf_range(PI * 0.1, PI * 0.9)
		var fuss := mitte + Vector2(cos(w) * radien.x * 1.02, sin(w) * radien.y * 1.02 - 2)
		var hoehe := _rng.randf_range(26, 42)
		draw_line(fuss, fuss + Vector2(2, -hoehe), TUSCHE, 3.2, true)
		draw_line(fuss, fuss + Vector2(2, -hoehe), MOOS[3], 1.8, true)
		_mit_umriss(_rund(fuss + Vector2(2, -hoehe - 4), Vector2(2.6, 6), 10), STAMM[2], 1.2)


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


## Glättet eine offene Linie (ohne die Enden zu verbinden).
func _glatt_offen(punkte: PackedVector2Array, runden: int) -> PackedVector2Array:
	for r in runden:
		var neu := PackedVector2Array([punkte[0]])
		for i in punkte.size() - 1:
			neu.append(punkte[i].lerp(punkte[i + 1], 0.25))
			neu.append(punkte[i].lerp(punkte[i + 1], 0.75))
		neu.append(punkte[punkte.size() - 1])
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
