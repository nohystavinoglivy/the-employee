extends "res://scripts/environments/BaseEnvironment.gd"

# ── The Commute Street ────────────────────────────────────────────────────────
# Gray urban. Morning sky. City scale dwarfs Beck.
# Parallax: sky, distant buildings, mid buildings, street level, foreground.
# This route is reused daily — Day 2 has one subtle change.

const STREET_WIDTH := 2400.0
const BUILDING_COUNT_FAR := 12
const BUILDING_COUNT_MID := 8

var _day2_change_visible: bool = false
var _destination_trigger_placed: bool = false

func _ready() -> void:
	room_right = STREET_WIDTH
	_day2_change_visible = GameState.current_day >= 2
	super._ready()

func _build_environment() -> void:
	_build_sky()
	_build_far_buildings()
	_build_mid_buildings()
	_build_street_level()
	_build_foreground()
	_build_npcs()
	_build_company_sign()
	_setup_destination_trigger()

func _build_sky() -> void:
	var layer: Node2D = _layers["far"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		# Sky gradient (morning)
		var sw := STREET_WIDTH + 400.0
		for i in range(20):
			var t := float(i) / 20.0
			var c := GameData.COL_SKY_MORNING.lerp(GameData.COL_SKY_HORIZON, t)
			n.draw_rect(Rect2(-200.0, -400.0 + float(i) * 20.0, sw, 22.0), c)
		# Sun (low, morning)
		n.draw_rect(Rect2(STREET_WIDTH * 0.65, -120, 24, 24), Color(1.0, 0.95, 0.70))
		n.draw_rect(Rect2(STREET_WIDTH * 0.65 - 4, -122, 32, 28), Color(1.0, 0.95, 0.70, 0.25))
	layer.add_child(draw_node)

func _build_far_buildings() -> void:
	var layer: Node2D = _layers["far"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		# Distant buildings silhouette
		var rng := RandomNumberGenerator.new()
		rng.seed = 12345
		var x := -100.0
		for i in range(BUILDING_COUNT_FAR):
			var w := float(rng.randi_range(60, 180))
			var h := float(rng.randi_range(150, 380))
			var col := GameData.COL_BLDG_FAR.lerp(GameData.COL_SKY_HORIZON, 0.3)
			n.draw_rect(Rect2(x, -h, w, h), col)
			# Windows grid (tiny, distant)
			for wy in range(0, int(h) - 20, 12):
				for wx in range(4, int(w) - 4, 10):
					var lit := rng.randf() > 0.4
					var wc := Color(0.85, 0.90, 0.75, 0.6) if lit else Color(0.20, 0.22, 0.28, 0.4)
					n.draw_rect(Rect2(x + float(wx), -h + float(wy) + 4.0, 5, 6), wc)
			x += w + float(rng.randi_range(4, 20))
	layer.add_child(draw_node)

func _build_mid_buildings() -> void:
	var layer: Node2D = _layers["mid"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		var rng := RandomNumberGenerator.new()
		rng.seed = 67890
		var x := -80.0
		for i in range(BUILDING_COUNT_MID):
			var w := float(rng.randi_range(120, 280))
			var h := float(rng.randi_range(200, 500))
			n.draw_rect(Rect2(x, -h, w, h + GameData.FLOOR_Y), GameData.COL_BLDG_MID)
			# Window rows
			for wy in range(10, int(h), 18):
				for wx in range(8, int(w) - 8, 16):
					var lit := rng.randf() > 0.5
					var wc := Color(0.80, 0.85, 0.70, 0.7) if lit else Color(0.15, 0.17, 0.22, 0.5)
					n.draw_rect(Rect2(x + float(wx), -h + float(wy), 8, 10), wc)
			# Day 2 change: one window display is different
			if _day2_change_visible and i == 3:
				n.draw_rect(Rect2(x + 50, -h + 100, 40, 50), Color(0.65, 0.60, 0.45, 0.8))
			x += w + float(rng.randi_range(0, 8))
	layer.add_child(draw_node)

func _build_street_level() -> void:
	var layer: Node2D = _layers["near"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		var SW := STREET_WIDTH
		# Sidewalk
		n.draw_rect(Rect2(-200, GameData.FLOOR_Y, SW + 400, 40), GameData.COL_SIDEWALK)
		# Sidewalk cracks / seams
		for sx in range(-200, int(SW) + 400, 48):
			n.draw_line(Vector2(float(sx), GameData.FLOOR_Y),
				Vector2(float(sx), GameData.FLOOR_Y + 40),
				Color(GameData.COL_STREET_SHADOW, 0.4), 1.0)
		# Road below sidewalk
		n.draw_rect(Rect2(-200, GameData.FLOOR_Y + 40, SW + 400, 80), GameData.COL_ROAD)
		# Road markings
		for mx in range(0, int(SW), 80):
			n.draw_rect(Rect2(float(mx), GameData.FLOOR_Y + 56, 40, 6),
				Color(0.85, 0.82, 0.60, 0.8))
		# Street shadows under buildings
		for i in range(0, int(SW), 200):
			n.draw_rect(Rect2(float(i), GameData.FLOOR_Y - 40, 30, 40),
				Color(GameData.COL_STREET_SHADOW, 0.45))
	layer.add_child(draw_node)

func _build_company_sign() -> void:
	var layer: Node2D = _layers["near"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		# Large company sign near end of street
		var sx := STREET_WIDTH - 600.0
		var sy := GameData.FLOOR_Y - 200.0
		# Sign backing
		n.draw_rect(Rect2(sx, sy, 180, 80), Color(0.08, 0.10, 0.22))
		n.draw_rect(Rect2(sx + 3, sy + 3, 174, 74), Color(0.10, 0.13, 0.28))
		# Gold border
		n.draw_rect(Rect2(sx, sy, 180, 4), GameData.COL_GOLD_DARK)
		n.draw_rect(Rect2(sx, sy + 76, 180, 4), GameData.COL_GOLD_DARK)
		n.draw_rect(Rect2(sx, sy, 4, 80), GameData.COL_GOLD_DARK)
		n.draw_rect(Rect2(sx + 176, sy, 4, 80), GameData.COL_GOLD_DARK)
		# Company logo glyph (religious-corporate — subtle)
		var cx := sx + 90.0
		var cy := sy + 30.0
		# Outer circle
		for a in range(0, 360, 10):
			var rad := deg_to_rad(float(a))
			var px := cx + cos(rad) * 18.0
			var py := cy + sin(rad) * 18.0
			n.draw_rect(Rect2(px - 1, py - 1, 2, 2), GameData.COL_GOLD)
		# Inner cross
		n.draw_rect(Rect2(cx - 1, cy - 14, 2, 28), GameData.COL_GOLD)
		n.draw_rect(Rect2(cx - 14, cy - 1, 28, 2), GameData.COL_GOLD)
		# Company name text bars
		n.draw_rect(Rect2(sx + 30, sy + 52, 120, 5), Color(GameData.COL_GOLD, 0.7))
		n.draw_rect(Rect2(sx + 50, sy + 60, 80, 4), Color(GameData.COL_GOLD, 0.5))
	layer.add_child(draw_node)

func _build_foreground() -> void:
	var layer: Node2D = _layers["fg"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		# Near building edges passing Beck in foreground
		for i in range(5):
			var fx := float(i) * 500.0 - 50.0
			n.draw_rect(Rect2(fx, -300, 24, 300 + GameData.FLOOR_Y),
				Color(GameData.COL_BLDG_MID, 0.85))
			# Edge shadow
			n.draw_rect(Rect2(fx + 24, -300, 8, 300 + GameData.FLOOR_Y),
				Color(GameData.COL_STREET_SHADOW, 0.5))
		# Street lamp poles
		for i in range(6):
			var lx := float(i) * 400.0 + 200.0
			n.draw_rect(Rect2(lx - 2, GameData.FLOOR_Y - 140, 4, 140), Color(0.35, 0.34, 0.36))
			n.draw_rect(Rect2(lx - 10, GameData.FLOOR_Y - 142, 20, 5), Color(0.35, 0.34, 0.36))
			# Lamp glow
			n.draw_circle(Vector2(lx, GameData.FLOOR_Y - 140.0), 8.0, Color(1.0, 0.95, 0.75, 0.8))
			n.draw_circle(Vector2(lx, GameData.FLOOR_Y - 140.0), 24.0, Color(1.0, 0.95, 0.75, 0.15))
	layer.add_child(draw_node)

func _build_npcs() -> void:
	var npc_script := load("res://scripts/entities/NPC.gd")

	# Passing NPC 1
	var npc1 := Node2D.new()
	npc1.set_script(npc_script)
	npc1.position = Vector2(300, GameData.FLOOR_Y - GameData.BECK_HEIGHT)
	npc1.npc_color = Color(0.45, 0.52, 0.60)
	npc1.walking = true
	npc1.walk_direction = 1.0
	npc1.walk_speed = 50.0
	npc1.dialogue_lines = Dialogue.NPC_MORNING_PASSING
	add_child(npc1)

	# Second NPC (stops Beck)
	var npc2 := Node2D.new()
	npc2.set_script(npc_script)
	npc2.position = Vector2(700, GameData.FLOOR_Y - GameData.BECK_HEIGHT)
	npc2.npc_color = Color(0.50, 0.48, 0.44)
	npc2.walking = false
	npc2.dialogue_lines = Dialogue.NPC_SECOND
	add_child(npc2)

	# Day 3 special NPC (looking directly at Beck)
	if GameState.current_day == 3:
		var npc3 := Node2D.new()
		npc3.set_script(npc_script)
		npc3.position = Vector2(500, GameData.FLOOR_Y - GameData.BECK_HEIGHT)
		npc3.npc_color = Color(0.55, 0.50, 0.46)
		npc3.walking = false
		npc3.dialogue_lines = Dialogue.NPC_DAY3_COMMUTE
		add_child(npc3)

func _setup_destination_trigger() -> void:
	var trigger := Area2D.new()
	var shape_node := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(40, 200)
	shape_node.shape = shape
	trigger.add_child(shape_node)
	trigger.position = Vector2(STREET_WIDTH - 60.0, GameData.FLOOR_Y - 100.0)
	trigger.body_entered.connect(_on_reach_office)
	add_child(trigger)

func _on_reach_office(body: Node) -> void:
	if body == beck:
		SceneManager.transition_to(GameData.SceneID.OFFICE_LOBBY, 0.6)

func _build_lighting() -> void:
	# Street is lit by ambient + street lamps
	ShadowSystem.add_point_light(self,
		Vector2(STREET_WIDTH / 2.0, GameData.FLOOR_Y - 300),
		Color(0.75, 0.80, 0.90), 0.3, 800, false)
	for i in range(6):
		ShadowSystem.add_point_light(self,
			Vector2(200.0 + float(i) * 400.0, GameData.FLOOR_Y - 135),
			Color(1.0, 0.95, 0.75), 1.4, 160, true)

func _start_ambient() -> void:
	AudioManager.play_ambient_street()

func get_beck_start_x() -> float:
	return 60.0

func get_bounds() -> Vector2:
	return Vector2(20.0, STREET_WIDTH - 20.0)
