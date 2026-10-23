# PROTOTYP – Wegwerf-Code! Vierte Runde: Vektor-Look wie ein SVG-Bild – glatte Formen mit
# sanften Farbverläufen, kräftige Farben, keine schwarzen Tusche-Linien, Kamera näher dran.
# Starten:  godot prototypes/stil/stil_vektor.tscn   (Argument „ohne_umriss" = ganz ohne Umrisse)
# Bilder:   prototypes/stil/bilder.sh
extends Node2D

## Dicke der dunklen Umrisse – im Vorbild sind alle Umrisse gleich dick.
## Dünner Umriss in einer dunkleren Farbe derselben Form (0 = gar kein Umriss).
var UMRISS := 2.5
## Für Augen und Gesicht bleibt es dunkel.
const TUSCHE := Color("#2e2430")
## Umriss-Farbe der Form, die gerade gezeichnet wird.
var _tusche := TUSCHE
## Wie nah die Kamera dran ist.
const ZOOM := 1.7
const BLICK_AUF := Vector2(760, 420)

## Farben: [Glanz, Grund, Schatten]
var GRAS := [Color("#b4e37c"), Color("#8fcf5f"), Color("#6fb04a")]
var GRAS_HALM := Color("#5f9e3e")
var ERDWAND := [Color("#e8b384"), Color("#d39563"), Color("#b0744a")]
var WASSER := [Color("#c4ecfa"), Color("#7ccbea"), Color("#5bb0d8")]
var STEIN := [Color("#d6d9dd"), Color("#a8adb4"), Color("#82878f")]
var LAUB := [Color("#a9dc7a"), Color("#6fbf5b"), Color("#4f9b46")]
var LAUB_DUNKEL := [Color("#8fcd73"), Color("#58a653"), Color("#3f8343")]
var HOLZ := [Color("#d9a46b"), Color("#b57a45"), Color("#8c5a32")]
var RINDE := [Color("#a7724c"), Color("#86563a"), Color("#68412b")]
var METALL := [Color("#d8dde3"), Color("#9aa3ad"), Color("#6f7782")]

var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	if "ohne_umriss" in OS.get_cmdline_user_args():
		UMRISS = 0.0
	# Alle Farben kräftiger machen (mehr Sättigung)
	for name in ["GRAS", "ERDWAND", "WASSER", "STEIN", "LAUB", "LAUB_DUNKEL", "HOLZ", "RINDE", "METALL"]:
		set(name, get(name).map(_satt))
	GRAS_HALM = _satt(GRAS_HALM)
	queue_redraw()


func _satt(c: Color) -> Color:
	return Color.from_hsv(c.h, minf(c.s * 1.35 + 0.06, 0.85), c.v * 0.86)


func _draw() -> void:
	_rng.seed = 5
	draw_set_transform(Vector2(640, 360) - BLICK_AUF * ZOOM, 0.0, Vector2.ONE * ZOOM)
	# Wasser ringsum
	_verlauf(PackedVector2Array([Vector2(-200, -200), Vector2(1500, -200), Vector2(1500, 900), Vector2(-200, 900)]), WASSER[0].lerp(WASSER[1], 0.5), WASSER[2])
	_wellen(Rect2(0, 0, 1280, 720))

	# Untere große Wiese und hintere, höhere Stufe
	var wiese := _glatt(PackedVector2Array([Vector2(-60, 120), Vector2(380, 60), Vector2(760, 110), Vector2(1340, 90),
		Vector2(1340, 560), Vector2(1000, 610), Vector2(620, 580), Vector2(260, 620), Vector2(-60, 590)]), 3)
	_plateau(wiese, 70.0)
	_bueschel_auf(wiese, 70)
	var oben := _glatt(PackedVector2Array([Vector2(780, -60), Vector2(1340, -60), Vector2(1340, 230), Vector2(1120, 250),
		Vector2(960, 210), Vector2(820, 160)]), 3)
	_plateau(oben, 90.0)
	_bueschel_auf(oben, 25)
	_hoehleneingang(Vector2(1050, 300))


	# Dinge von hinten nach vorne
	_stein(Vector2(1170, 120), 26)
	_baum(Vector2(250, 300), 1.1, LAUB_DUNKEL)
	_baum(Vector2(120, 360), 1.25, LAUB)
	_baum(Vector2(380, 360), 0.9, LAUB)
	_wegweiser(Vector2(860, 330))
	_busch(Vector2(560, 300))
	_stein(Vector2(80, 470), 34)
	_stein(Vector2(130, 490), 20)
	_truhe(Vector2(470, 410))
	_holzstapel(Vector2(260, 480))
	_stumpf(Vector2(640, 500))
	_pilz(Vector2(590, 520), 1.0)
	_pilz(Vector2(700, 525), 0.85)
	_figur(Vector2(780, 450))
	_stein(Vector2(1060, 660), 30)


# ---- Gelände -------------------------------------------------------------------

## Eine Gras-Fläche, die als Plateau mit Erdwand über dem Boden darunter liegt.
func _plateau(oben: PackedVector2Array, hoehe: float) -> void:
	var unten := _verschieben(oben, Vector2(0, hoehe))
	# Umriss: Oberseite + nach unten verschobene Kopie + Verbindungen
	var teile := [oben, unten]
	for i in oben.size():
		var a := oben[i]
		var b := oben[(i + 1) % oben.size()]
		teile.append(PackedVector2Array([a, b, b + Vector2(0, hoehe), a + Vector2(0, hoehe)]))
	_tusche = ERDWAND[2].darkened(0.4)
	for t in teile:
		draw_colored_polygon(Geometry2D.offset_polygon(t, UMRISS)[0], _tusche)
	for t in teile.slice(1):
		_verlauf(t, ERDWAND[1], ERDWAND[2])
	# Wand-Details: senkrechte dunkle Streifen und helle Ziegel-Flecken
	for i in oben.size():
		var a := oben[i]
		var b := oben[(i + 1) % oben.size()]
		if not _vorne(a, b, oben):
			continue  # nur Kanten, die nach vorne (unten) zeigen, haben eine sichtbare Wand
		if i % 3 == 0:
			draw_rect(Rect2(a + Vector2(0, 14), Vector2(10, hoehe - 22)), ERDWAND[2])
		if i % 4 == 1:
			draw_rect(Rect2(a + Vector2(4, hoehe * 0.45), Vector2(18, 9)), ERDWAND[0])
	# Grasfläche oben
	draw_colored_polygon(oben, GRAS[1])
	draw_colored_polygon(_skalieren(oben, _mitte(oben) + Vector2(-200, -120), 0.82), GRAS[0].lerp(GRAS[1], 0.55))
	# Gras-Kante, die über die Wand hängt (Bögen)
	var boegen := []
	for i in oben.size():
		var a := oben[i]
		var b := oben[(i + 1) % oben.size()]
		if not _vorne(a, b, oben):
			continue
		var n := int(a.distance_to(b) / 22.0) + 1
		for k in n:
			boegen.append([a.lerp(b, (k + 0.5) / n) + Vector2(0, 2), _rng.randf_range(10, 14)])
	_tusche = GRAS[2].darkened(0.35)
	for bg in boegen:
		draw_circle(bg[0], bg[1] + UMRISS, _tusche, true, -1.0, true)
	for bg in boegen:
		draw_circle(bg[0], bg[1], GRAS[2], true, -1.0, true)
	# Wiese nochmal darüber, damit von den Bögen nur der untere Rand über die Wand hängt
	_verlauf(oben, GRAS[0].lerp(GRAS[1], 0.4), GRAS[1].lerp(GRAS[2], 0.4))


## Zeigt die Kante a→b nach vorne (unten), also zu uns? Dann sieht man darunter die Wand.
func _vorne(a: Vector2, b: Vector2, form: PackedVector2Array) -> bool:
	var normale := (b - a).orthogonal().normalized()
	var mitte := (a + b) / 2.0
	if Geometry2D.is_point_in_polygon(mitte + normale * 3.0, form):
		normale = -normale  # zeigte nach innen
	return normale.y > 0.3


func _wellen(feld: Rect2) -> void:
	for i in 40:
		var p := Vector2(_rng.randf_range(feld.position.x, feld.end.x), _rng.randf_range(feld.position.y, feld.end.y))
		draw_arc(p, 14.0, PI * 1.15, PI * 1.85, 10, WASSER[0], 3.0, true)
		draw_arc(p + Vector2(22, 3), 10.0, PI * 1.15, PI * 1.85, 10, WASSER[0], 3.0, true)


## Verstreut Grasbüschel auf einer Fläche (nicht zu nah am Rand).
func _bueschel_auf(flaeche: PackedVector2Array, anzahl: int) -> void:
	var innen := Geometry2D.offset_polygon(flaeche, -20)[0]
	var gesetzt := 0
	while gesetzt < anzahl:
		var p := Vector2(_rng.randf_range(0, 1280), _rng.randf_range(0, 600))
		if Geometry2D.is_point_in_polygon(p, innen):
			_bueschel(p)
			gesetzt += 1


func _bueschel(p: Vector2) -> void:
	for h in [-1, 0, 1]:
		draw_polyline(PackedVector2Array([p + Vector2(h * 4, 0), p + Vector2(h * 7, -9 + absi(h) * 3)]), GRAS_HALM, 3.0, true)


func _hoehleneingang(p: Vector2) -> void:
	var bogen := PackedVector2Array()
	for i in 17:
		var w := PI + PI * i / 16.0
		bogen.append(p + Vector2(cos(w) * 34, sin(w) * 40))
	bogen.append(p + Vector2(34, 22))
	bogen.append(p + Vector2(-34, 22))
	draw_colored_polygon(Geometry2D.offset_polygon(bogen, UMRISS + 6)[0], STEIN[2].darkened(0.4))
	draw_colored_polygon(Geometry2D.offset_polygon(bogen, 6)[0], STEIN[1])
	draw_colored_polygon(bogen, Color("#1c1622"))
	for i in 5:  # Steine im Bogen
		var w := PI + PI * (i + 0.5) / 5.0
		_stein(p + Vector2(cos(w) * 40, sin(w) * 46 + 6), 9)


# ---- Dinge ---------------------------------------------------------------------

## Füllt eine Form im Vektor-Stil: dünner Umriss in dunklerer Eigenfarbe, Farbverlauf
## von hell (oben) nach dunkel (unten) und ein weicher Glanz oben links.
func _form(f: PackedVector2Array, farben: Array, mit_umriss := true) -> void:
	var m := _mitte(f)
	var groesse := _groesse(f)
	_tusche = farben[2].darkened(0.4)
	if mit_umriss and UMRISS > 0.0:
		draw_colored_polygon(Geometry2D.offset_polygon(f, UMRISS)[0], _tusche)
	_verlauf(f, farben[1].lerp(farben[0], 0.35), farben[2])
	# Glanz oben links – aber nur, wenn er ganz in der Form liegt (bei dünnen Formen nicht)
	var glanz_pos := m - groesse * 0.22
	var glanz_r := minf(groesse.x, groesse.y) * 0.18
	var innen := Geometry2D.offset_polygon(f, -glanz_r)
	if innen.size() > 0 and Geometry2D.is_point_in_polygon(glanz_pos, innen[0]):
		_glanz(glanz_pos, glanz_r, farben[0])


## Füllt eine Form mit einem senkrechten Farbverlauf (wie ein SVG-„linearGradient").
func _verlauf(f: PackedVector2Array, oben: Color, unten: Color) -> void:
	var r := Rect2(f[0], Vector2.ZERO)
	for p in f:
		r = r.expand(p)
	var farben := PackedColorArray()
	for p in f:
		farben.append(oben.lerp(unten, (p.y - r.position.y) / maxf(r.size.y, 1.0)))
	draw_polygon(f, farben)


func _kreis(mitte: Vector2, radius: float, oben: Color, unten: Color) -> void:
	_verlauf(_rund(mitte, Vector2(radius, radius), 28), oben, unten)


func _glanz(p: Vector2, r: float, farbe: Color) -> void:
	var c := farbe
	c.a = 0.8
	draw_colored_polygon(_rund(p, Vector2(r * 0.8, r * 0.5), 18), c)
	draw_circle(p + Vector2(r * 1.1, r * 0.15), r * 0.2, c, true, -1.0, true)


func _stein(fuss: Vector2, r: float) -> void:
	_schatten(fuss + Vector2(4, 2), Vector2(r * 1.1, r * 0.35))
	_form(_rund(fuss - Vector2(0, r * 0.55), Vector2(r, r * 0.75), 20), STEIN)


## Ein knuffiger Baum: Stamm und eine Krone aus großen runden Wolken mit „w"-Blättchen.
func _baum(fuss: Vector2, g: float, farben: Array) -> void:
	_schatten(fuss + Vector2(10, 4) * g, Vector2(60, 16) * g)
	var stamm := PackedVector2Array([fuss + Vector2(-14, 0) * g, fuss + Vector2(14, 0) * g, fuss + Vector2(10, -70) * g, fuss + Vector2(-10, -70) * g])
	_form(stamm, RINDE)
	var wolken := [[Vector2(-40, -110), 42], [Vector2(32, -112), 40], [Vector2(-4, -150), 44], [Vector2(0, -95), 38]]
	_tusche = farben[2].darkened(0.4)
	for w in wolken:
		draw_circle(fuss + w[0] * g, (w[1] + UMRISS / g) * g, _tusche, true, -1.0, true)
	for w in wolken:
		_kreis(fuss + w[0] * g, w[1] * g, farben[1], farben[2])
	for w in wolken:
		_kreis(fuss + (w[0] + Vector2(-5, -6)) * g, w[1] * 0.8 * g, farben[0].lerp(farben[1], 0.5), farben[1])
	_glanz(fuss + Vector2(-22, -170) * g, 13 * g, farben[0])
	_glanz(fuss + Vector2(-58, -128) * g, 9 * g, farben[0])
	for p in [Vector2(-30, -120), Vector2(20, -138), Vector2(10, -100), Vector2(-50, -96)]:  # „w"-Blättchen
		_w_zeichen(fuss + p * g, 6 * g, farben[2])


func _w_zeichen(p: Vector2, r: float, farbe: Color) -> void:
	draw_arc(p, r, 0.15, PI - 0.15, 10, farbe, 3.0, true)
	draw_arc(p + Vector2(r * 2, 0), r, 0.15, PI - 0.15, 10, farbe, 3.0, true)


func _busch(fuss: Vector2) -> void:
	_schatten(fuss + Vector2(6, 3), Vector2(46, 12))
	var wolken := [[Vector2(-24, -20), 22], [Vector2(20, -22), 22], [Vector2(-2, -34), 24]]
	_tusche = LAUB[2].darkened(0.4)
	for w in wolken:
		draw_circle(fuss + w[0], w[1] + UMRISS, _tusche, true, -1.0, true)
	for w in wolken:
		_kreis(fuss + w[0], w[1], LAUB[1], LAUB[2])
		_kreis(fuss + w[0] + Vector2(-3, -4), w[1] * 0.8, LAUB[0].lerp(LAUB[1], 0.5), LAUB[1])
	for b in [Vector2(-20, -18), Vector2(8, -30), Vector2(22, -16), Vector2(-6, -12)]:  # Beeren
		draw_circle(fuss + b, 5.5 + UMRISS * 0.6, Color("#8a1a2c"), true, -1.0, true)
		_kreis(fuss + b, 5.5, Color("#ff6b7f"), Color("#c8203d"))
		draw_circle(fuss + b + Vector2(-1.8, -1.8), 1.6, Color.WHITE, true, -1.0, true)
	_glanz(fuss + Vector2(-14, -44), 7, LAUB[0])


## Eine Schatztruhe: Kasten mit gewölbtem Deckel, Seitenwand, Metallbändern und Goldschloss.
func _truhe(fuss: Vector2) -> void:
	var gold := [Color("#ffe48a"), Color("#f4c23a"), Color("#c48f17")]
	var b := 34.0   # halbe Breite
	var h := 30.0   # Höhe des Kastens
	var tiefe := Vector2(12, -9)  # so weit sieht man die rechte Seite
	_schatten(fuss + Vector2(10, 3), Vector2(50, 11))
	# Formen
	var kasten := PackedVector2Array([fuss + Vector2(-b, -h), fuss + Vector2(b, -h), fuss + Vector2(b, 0), fuss + Vector2(-b, 0)])
	var kasten_seite := PackedVector2Array([fuss + Vector2(b, 0), fuss + Vector2(b, -h), fuss + Vector2(b, -h) + tiefe, fuss + Vector2(b, 0) + tiefe])
	var deckel := PackedVector2Array([fuss + Vector2(-b - 2, -h + 2), fuss + Vector2(b + 2, -h + 2)])
	for i in 13:  # gewölbter Deckel: Bogen von rechts nach links
		var w := lerpf(0.0, PI, i / 12.0)
		deckel.append(fuss + Vector2(cos(w) * (b + 2), -h - 6 - sin(w) * 20))
	# Rückseite des Deckels: dieselbe Form, nach hinten versetzt – das gibt die Tiefe
	var deckel_hinten := _verschieben(deckel, tiefe)
	var deckel_seite := PackedVector2Array([fuss + Vector2(b + 2, -h + 2), fuss + Vector2(b + 2, -h - 6),
		fuss + Vector2(b + 2, -h - 6) + tiefe, fuss + Vector2(b + 2, -h + 2) + tiefe])
	# Umriss außen herum, dann Füllungen
	for f in [kasten, kasten_seite, deckel_hinten, deckel_seite, deckel]:
		draw_colored_polygon(Geometry2D.offset_polygon(f, UMRISS)[0], HOLZ[2].darkened(0.45))
	_verlauf(kasten, HOLZ[1], HOLZ[2])
	_verlauf(kasten_seite, HOLZ[2], HOLZ[2].darkened(0.25))
	_verlauf(deckel_hinten, HOLZ[2], HOLZ[2].darkened(0.2))
	_verlauf(deckel_seite, HOLZ[2], HOLZ[2].darkened(0.2))
	_verlauf(deckel, HOLZ[0], HOLZ[1])
	# Holzbretter
	draw_line(fuss + Vector2(-b + 2, -h * 0.5), fuss + Vector2(b - 2, -h * 0.5), HOLZ[2].darkened(0.15), 2.0, true)
	for x in [-b * 0.55, b * 0.55]:
		draw_line(fuss + Vector2(x, -h - 10), fuss + Vector2(x * 0.9, -h - 22), HOLZ[1].darkened(0.1), 2.0, true)
	# dunkler Spalt zwischen Deckel und Kasten
	draw_line(fuss + Vector2(-b - 2, -h + 2), fuss + Vector2(b + 2, -h + 2), HOLZ[2].darkened(0.5), 3.0, true)
	# Metallbänder (über Kasten und Deckel)
	for x in [-b * 0.62, b * 0.62]:
		var streifen := PackedVector2Array([fuss + Vector2(x - 4, 2), fuss + Vector2(x + 4, 2), fuss + Vector2(x + 4, -h - 40), fuss + Vector2(x - 4, -h - 40)])
		for teil in Geometry2D.intersect_polygons(streifen, kasten) + Geometry2D.intersect_polygons(streifen, deckel):
			_verlauf(teil, METALL[0], METALL[2])
		draw_circle(fuss + Vector2(x, -h * 0.25), 1.6, METALL[2].darkened(0.3), true, -1.0, true)  # Nieten
		draw_circle(fuss + Vector2(x, -h * 0.75), 1.6, METALL[2].darkened(0.3), true, -1.0, true)
	# Goldschloss mit Schlüsselloch
	var schloss := _glatt(PackedVector2Array([fuss + Vector2(-8, -h - 6), fuss + Vector2(8, -h - 6), fuss + Vector2(8, -h + 10), fuss + Vector2(-8, -h + 10)]), 2)
	_form(schloss, gold)
	draw_circle(fuss + Vector2(0, -h + 1), 2.6, Color("#3a2a12"), true, -1.0, true)
	draw_colored_polygon(PackedVector2Array([fuss + Vector2(-1.6, -h + 2), fuss + Vector2(1.6, -h + 2), fuss + Vector2(2.4, -h + 7), fuss + Vector2(-2.4, -h + 7)]), Color("#3a2a12"))
	# Glanz auf dem Deckel
	_glanz(fuss + Vector2(-b * 0.45, -h - 18), 6, HOLZ[0].lightened(0.3))


func _holzstapel(fuss: Vector2) -> void:
	_schatten(fuss + Vector2(10, 4), Vector2(70, 14))
	for s in [[Vector2(-30, -16), 0], [Vector2(20, -18), 0], [Vector2(-6, -44), 0]]:
		var p: Vector2 = fuss + s[0]
		var koerper := PackedVector2Array([p + Vector2(-38, -16), p + Vector2(26, -16), p + Vector2(26, 16), p + Vector2(-38, 16)])
		_form(koerper, RINDE)
		var ende := _rund(p + Vector2(-38, 0), Vector2(13, 16), 18)
		draw_colored_polygon(Geometry2D.offset_polygon(ende, UMRISS)[0], RINDE[2].darkened(0.4))
		draw_colored_polygon(ende, HOLZ[0])
		draw_arc(p + Vector2(-38, 0), 8.0, 0, TAU, 16, HOLZ[1], 2.0, true)


func _stumpf(fuss: Vector2) -> void:
	_schatten(fuss + Vector2(8, 4), Vector2(50, 14))
	var koerper := PackedVector2Array([fuss + Vector2(-42, 0), fuss + Vector2(-34, -10), fuss + Vector2(-30, -48),
		fuss + Vector2(30, -48), fuss + Vector2(34, -10), fuss + Vector2(44, 0), fuss + Vector2(12, -4), fuss + Vector2(0, 2), fuss + Vector2(-14, -4)])
	_form(koerper, RINDE)
	var oben := _rund(fuss + Vector2(0, -48), Vector2(31, 12), 20)
	draw_colored_polygon(Geometry2D.offset_polygon(oben, UMRISS)[0], RINDE[2].darkened(0.4))
	draw_colored_polygon(oben, HOLZ[0])
	draw_arc(fuss + Vector2(0, -48), 16.0, 0, TAU, 20, HOLZ[1], 2.0, true)
	_axt(fuss + Vector2(0, -48))


## Eine Axt, die im Holz steckt. „oberflaeche" ist die Mitte der Holzoberfläche.
## Der Axtkopf sitzt quer zum Stiel: hinten der stumpfe Nacken, vorne die gebogene Schneide,
## die schräg ins Holz geht. Was unter der Oberfläche liegt, wird abgeschnitten.
func _axt(oberflaeche: Vector2) -> void:
	var d := Vector2(0.75, -0.66).normalized()  # Richtung des Stiels (nach oben rechts)
	var q := Vector2(0.66, 0.75).normalized()   # quer dazu: Richtung der Schneide (ins Holz)
	var auge := oberflaeche + Vector2(-4, -16)  # wo der Stiel durch den Kopf geht
	var schnitt_y := oberflaeche.y + 1.0        # hier verschwindet die Schneide im Holz
	# Axtkopf in eigenen Koordinaten: u entlang q (Schneide), v entlang d (Stiel)
	var umriss := [Vector2(-9, -5), Vector2(2, -7.5), Vector2(8, -5.5), Vector2(19, -13)]
	for i in 9:  # gebogene Schneide
		var w := lerpf(-1.0, 1.0, i / 8.0)
		umriss.append(Vector2(19 + cos(w * 1.1) * 8, w * 13))
	umriss += [Vector2(19, 13), Vector2(8, 5.5), Vector2(2, 7.5), Vector2(-9, 5)]
	var kopf := PackedVector2Array()
	for p in umriss:
		kopf.append(auge + q * p.x + d * p.y)
	var ueber_holz := PackedVector2Array([Vector2(auge.x - 80, auge.y - 80), Vector2(auge.x + 80, auge.y - 80),
		Vector2(auge.x + 80, schnitt_y), Vector2(auge.x - 80, schnitt_y)])
	var sichtbar := Geometry2D.intersect_polygons(kopf, ueber_holz)
	# Spalt im Holz zuerst (unter dem Kopf): genau dort, wo die Schneide eintaucht
	var links := INF
	var rechts := -INF
	for teil in sichtbar:
		for p in teil:
			if absf(p.y - schnitt_y) < 0.5:
				links = minf(links, p.x)
				rechts = maxf(rechts, p.x)
	if links < rechts:
		draw_line(Vector2(links - 4, schnitt_y + 1), Vector2(rechts + 4, schnitt_y + 1), RINDE[2].darkened(0.45), 3.5, true)
	# Stiel mit Knauf am Ende
	var stiel := PackedVector2Array([auge - d * 2 + q * 3.5, auge - d * 2 - q * 3.5, auge + d * 70 - q * 3, auge + d * 70 + q * 3])
	_form(stiel, HOLZ)
	_form(_rund(auge + d * 70, Vector2(5, 5), 14), HOLZ)
	# Kopf
	for teil in sichtbar:
		_form(teil, METALL)
	# blanker Streifen entlang der Schneide – nur der Teil über dem Holz
	var blank := PackedVector2Array()
	for i in 9:
		var w := lerpf(-1.0, 1.0, i / 8.0)
		blank.append(auge + q * (19 + cos(w * 1.1) * 8) + d * (w * 13))
	for i in 9:
		var w := lerpf(1.0, -1.0, i / 8.0)
		blank.append(auge + q * (17 + cos(w * 1.1) * 5) + d * (w * 10))
	for teil in sichtbar:
		for streifen in Geometry2D.intersect_polygons(blank, teil):
			draw_colored_polygon(streifen, METALL[0].lightened(0.25))
	# Loch für den Stiel
	draw_circle(auge, 3.0, METALL[2].darkened(0.35), true, -1.0, true)


func _pilz(fuss: Vector2, g: float) -> void:
	_schatten(fuss + Vector2(3, 2), Vector2(16, 5) * g)
	_form(PackedVector2Array([fuss + Vector2(-6, 0) * g, fuss + Vector2(6, 0) * g, fuss + Vector2(5, -16) * g, fuss + Vector2(-5, -16) * g]),
		[Color("#ffffff"), Color("#f7eedc"), Color("#dcccae")])
	var hut := _rund(fuss + Vector2(0, -20) * g, Vector2(18, 13) * g, 18)
	_form(hut, [Color("#ff8f86"), Color("#e8413a"), Color("#b92c2c")])
	for d in [Vector2(-8, -24), Vector2(5, -27), Vector2(9, -17), Vector2(-3, -15)]:
		draw_circle(fuss + d * g, 3.0 * g, Color.WHITE, true, -1.0, true)


func _wegweiser(fuss: Vector2) -> void:
	_schatten(fuss + Vector2(6, 3), Vector2(20, 6))
	_form(PackedVector2Array([fuss + Vector2(-6, 0), fuss + Vector2(6, 0), fuss + Vector2(6, -110), fuss + Vector2(-6, -110)]), HOLZ)
	var schild := PackedVector2Array([fuss + Vector2(-4, -100), fuss + Vector2(52, -100), fuss + Vector2(64, -86), fuss + Vector2(52, -72), fuss + Vector2(-4, -72)])
	_form(schild, HOLZ)
	draw_line(fuss + Vector2(8, -86), fuss + Vector2(40, -86), HOLZ[2], 3.0, true)


# ---- Figur ---------------------------------------------------------------------

## Die Spielfigur als knuffiger Chibi: großer Kopf, kleiner Körper, kleines Schwert.
func _figur(fuss: Vector2) -> void:
	_schatten(fuss + Vector2(4, 2), Vector2(28, 8))
	var haut := [Color("#ffe9d6"), Color("#ffd3ad"), Color("#eab08a")]
	var umhang := [Color("#a9d0ff"), Color("#5f9ef0"), Color("#3c74c4")]
	var haare := [Color("#c98b5c"), Color("#8a5533"), Color("#673d24")]
	var beine := [fuss + Vector2(-10, 0), fuss + Vector2(9, 0)]
	for b in beine:
		_form(_rund(b + Vector2(0, -6), Vector2(7, 7), 12), [Color("#8f6a55"), Color("#6b4a3a"), Color("#4e3428")])
	_form(_rund(fuss + Vector2(0, -26), Vector2(20, 20), 20), umhang)  # Körper
	# Schwert in der rechten Hand
	_form(PackedVector2Array([fuss + Vector2(24, -30), fuss + Vector2(30, -32), fuss + Vector2(44, -74), fuss + Vector2(38, -76)]), METALL)
	_form(_rund(fuss + Vector2(26, -28), Vector2(9, 4), 10), HOLZ)
	_form(_rund(fuss + Vector2(22, -26), Vector2(7, 7), 12), haut)  # Hand
	# Großer Kopf mit Haaren
	var kopf := _rund(fuss + Vector2(0, -68), Vector2(32, 29), 26)
	_form(kopf, haut)
	var haar := PackedVector2Array()
	for i in 13:
		var w := PI + PI * i / 12.0
		haar.append(fuss + Vector2(0, -74) + Vector2(cos(w) * 35, sin(w) * 28))
	haar.append(fuss + Vector2(26, -70))
	haar.append(fuss + Vector2(14, -82))
	haar.append(fuss + Vector2(0, -74))
	haar.append(fuss + Vector2(-14, -82))
	haar.append(fuss + Vector2(-26, -70))
	_form(haar, haare)
	# Gesicht
	for x in [-11, 11]:
		draw_colored_polygon(_rund(fuss + Vector2(x, -62), Vector2(4.5, 6), 12), TUSCHE)
		draw_circle(fuss + Vector2(x - 1.5, -64.5), 1.8, Color.WHITE, true, -1.0, true)
	for x in [-20, 20]:
		draw_colored_polygon(_rund(fuss + Vector2(x, -54), Vector2(5, 3), 10), Color(1, 0.45, 0.5, 0.45))
	draw_arc(fuss + Vector2(0, -55), 4.0, 0.3, PI - 0.3, 8, TUSCHE, 2.5, true)


# ---- Helfer ----------------------------------------------------------------------

func _schatten(mitte: Vector2, radien: Vector2) -> void:
	draw_colored_polygon(_rund(mitte, radien, 20), Color(0.15, 0.3, 0.12, 0.25))


func _rund(mitte: Vector2, radien: Vector2, ecken: int) -> PackedVector2Array:
	var punkte := PackedVector2Array()
	for i in ecken:
		var w := TAU * i / ecken
		punkte.append(mitte + Vector2(cos(w) * radien.x, sin(w) * radien.y))
	return punkte


## Rundet Ecken ab (Chaikin): aus jeder Ecke werden zwei Punkte.
func _glatt(punkte: PackedVector2Array, runden: int) -> PackedVector2Array:
	for r in runden:
		var neu := PackedVector2Array()
		for i in punkte.size():
			var a := punkte[i]
			var b := punkte[(i + 1) % punkte.size()]
			neu.append(a.lerp(b, 0.25))
			neu.append(a.lerp(b, 0.75))
		punkte = neu
	return punkte


func _mitte(punkte: PackedVector2Array) -> Vector2:
	var summe := Vector2.ZERO
	for p in punkte:
		summe += p
	return summe / punkte.size()


func _groesse(punkte: PackedVector2Array) -> Vector2:
	var r := Rect2(punkte[0], Vector2.ZERO)
	for p in punkte:
		r = r.expand(p)
	return r.size


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
