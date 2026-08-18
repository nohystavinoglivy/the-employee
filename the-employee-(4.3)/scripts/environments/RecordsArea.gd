extends "res://scripts/environments/BaseEnvironment.gd"

# ── Records Area — 3rd Floor ──────────────────────────────────────────────────
# Claustrophobic. Less open than the workstation floor.
# Rows of shelves. Filing systems. Repeated architecture. Dimmer.
# Day 3 content: Records Employee NPC, delivery task.

const RECORDS_W := 1800.0

var _records_employee: Node2D = null

func _ready() -> void:
	room_right = RECORDS_W
	super._ready()
	_trigger_day3_events()

func _build_environment() -> void:
	_build_far_bg()
	_build_walls()
	_build_floor()
	_build_shelves()
	_build_details()
	_build_exits()
	_build_npcs()

func _build_far_bg() -> void:
	var layer: Node2D = _layers["far"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		# Very dark, felt-heavy background — almost no light reaches here
		n.draw_rect(Rect2(-200, -800, RECORDS_W + 400, 800 + GameData.VIEWPORT_H),
			Color(0.06, 0.07, 0.12))
		# Barely-visible distant shelves fading to dark
		for i in range(6):
			var sx := float(i) * 300.0 - 100.0
			n.draw_rect(Rect2(sx, -600, 12, 600 + GameData.FLOOR_Y),
				Color(0.09, 0.10, 0.16, 0.6))
	layer.add_child(draw_node)

func _build_walls() -> void:
	var layer: Node2D = _layers["mid"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		var RW := RECORDS_W
		# Wall — darker and more oppressive than main floor
		n.draw_rect(Rect2(-200, -500, RW + 400, 500 + GameData.FLOOR_Y),
			Color(0.11, 0.12, 0.18))
		# Low ceiling (oppressive)
		n.draw_rect(Rect2(-200, -220, RW + 400, 30), Color(0.08, 0.09, 0.14))
		n.draw_rect(Rect2(-200, -220, RW + 400, 4), Color(GameData.COL_OFF_TRIM, 0.35))
		# Fluorescent strip lights — fewer, dimmer
		for lx in range(-200, int(RW) + 200, 200):
			n.draw_rect(Rect2(float(lx) + 30, -220, 140, 6),
				Color(0.60, 0.68, 0.90, 0.55))
		# Baseboard
		n.draw_rect(Rect2(-200, GameData.FLOOR_Y - 12, RW + 400, 12),
			Color(0.08, 0.09, 0.14))
		n.draw_rect(Rect2(-200, GameData.FLOOR_Y - 14, RW + 400, 2),
			Color(GameData.COL_OFF_TRIM, 0.4))
		# Wall seams — horizontal crack lines for age/grime
		for wy in [-400, -320, -150]:
			n.draw_rect(Rect2(-200, float(wy), RW + 400, 1), Color(0.05, 0.06, 0.10, 0.8))
		# Duct / conduit pipe along ceiling
		n.draw_rect(Rect2(-200, -200, RW + 400, 10), Color(0.14, 0.16, 0.22))
		n.draw_rect(Rect2(-200, -202, RW + 400, 2), Color(GameData.COL_OFF_TRIM, 0.2))
	layer.add_child(draw_node)

func _build_floor() -> void:
	var layer: Node2D = _layers["near"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		var RW := RECORDS_W
		# Worn linoleum — duller than main floor
		n.draw_rect(Rect2(-200, GameData.FLOOR_Y, RW + 400, 200), Color(0.13, 0.14, 0.19))
		for tx in range(-200, int(RW) + 400, 48):
			n.draw_line(Vector2(float(tx), GameData.FLOOR_Y),
				Vector2(float(tx), GameData.FLOOR_Y + 200),
				Color(GameData.COL_OFF_SHADOW, 0.2), 1.0)
		# Scuff marks
		for i in range(12):
			var scx := float(i) * 150.0 + 20.0
			n.draw_rect(Rect2(scx, GameData.FLOOR_Y + 4, 24, 2),
				Color(0.10, 0.11, 0.16, 0.8))
	layer.add_child(draw_node)

func _build_shelves() -> void:
	var layer: Node2D = _layers["near"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		# Two rows of filing shelves — alternating close/far rows
		# Row 1 (near, full height)
		_draw_shelf_row(n, 60.0, false)
		# Row 2 (behind row 1 — drawn slightly higher for depth)
		_draw_shelf_row(n, 480.0, false)
		# Row 3 — right wing
		_draw_shelf_row(n, 900.0, true)
		# Row 4 — right end
		_draw_shelf_row(n, 1320.0, false)
	layer.add_child(draw_node)

func _draw_shelf_row(n: Node2D, start_x: float, archive: bool) -> void:
	# A single long shelving unit: 8 bay segments, each 44px wide
	var BAYS := 8
	var BAY_W := 44.0
	var SHELF_H := GameData.FLOOR_Y - 30.0  # top of shelf = high on wall
	var SHELF_TOP := -170.0  # top y
	var shelf_col := Color(0.16, 0.17, 0.23) if not archive else Color(0.14, 0.16, 0.22)
	var frame_col := Color(0.20, 0.22, 0.30) if not archive else Color(0.18, 0.20, 0.28)

	# Vertical uprights
	for i in range(BAYS + 1):
		n.draw_rect(Rect2(start_x + float(i) * BAY_W - 3, SHELF_TOP,
			6, SHELF_H - SHELF_TOP), frame_col)

	# Horizontal shelf boards (5 per bay)
	for shelf in range(5):
		var sy := SHELF_TOP + float(shelf) * 36.0
		n.draw_rect(Rect2(start_x - 4, sy, float(BAYS) * BAY_W + 8, 5), frame_col)
		# Files/folders on each shelf
		for bay in range(BAYS):
			var bx := start_x + float(bay) * BAY_W + 4.0
			# Different colored file spines per bay for variety
			var file_cols := [
				Color(0.55, 0.25, 0.18),  # red
				Color(0.22, 0.40, 0.56),  # blue
				Color(0.45, 0.42, 0.20),  # tan
				Color(0.25, 0.42, 0.28),  # green
				Color(0.55, 0.45, 0.20),  # gold
				Color(0.40, 0.28, 0.48),  # purple
				Color(0.48, 0.46, 0.42),  # gray
				Color(0.60, 0.38, 0.22),  # orange
			]
			var fc := file_cols[bay % file_cols.size()]
			# Stack of files
			for fi in range(6):
				var fx := bx + float(fi) * 5.5
				if fx + 4 < bx + BAY_W - 4:
					n.draw_rect(Rect2(fx, sy + 5, 4, 30), fc.darkened(float(fi) * 0.04))
					# Label strip
					n.draw_rect(Rect2(fx, sy + 8, 4, 5), Color(0.85, 0.82, 0.75, 0.6))

	# Bottom shelf board
	n.draw_rect(Rect2(start_x - 4, SHELF_H - 5, float(BAYS) * BAY_W + 8, 5), frame_col)
	# Backing plate
	n.draw_rect(Rect2(start_x - 2, SHELF_TOP, float(BAYS) * BAY_W + 4, SHELF_H - SHELF_TOP),
		shelf_col)
	# Top cap
	n.draw_rect(Rect2(start_x - 6, SHELF_TOP - 4, float(BAYS) * BAY_W + 12, 4), frame_col)

func _build_details() -> void:
	var layer: Node2D = _layers["near"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		# Records desk (where employee sits)
		n.draw_rect(Rect2(1540, GameData.FLOOR_Y - 55, 220, 55), Color(0.14, 0.15, 0.22))
		n.draw_rect(Rect2(1538, GameData.FLOOR_Y - 57, 224, 4), Color(GameData.COL_OFF_TRIM, 0.5))
		# Terminal screen (older — green phosphor style)
		n.draw_rect(Rect2(1620, GameData.FLOOR_Y - 88, 60, 40), Color(0.08, 0.14, 0.08))
		n.draw_rect(Rect2(1622, GameData.FLOOR_Y - 86, 56, 36), Color(0.04, 0.10, 0.04))
		for row in range(4):
			n.draw_rect(Rect2(1626.0, GameData.FLOOR_Y - 82.0 + float(row) * 7.0, 48, 3),
				Color(0.30, 0.90, 0.30, 0.7))
		# Stack of files/papers on desk
		for i in range(3):
			n.draw_rect(Rect2(1548.0 + float(i) * 3.0, GameData.FLOOR_Y - 56.0 + float(i) * 1.5,
				40, 4), Color(0.80, 0.76, 0.66))
		# Cart with files (near desk)
		n.draw_rect(Rect2(1490, GameData.FLOOR_Y - 60, 30, 60), Color(0.20, 0.22, 0.28))
		for ci in range(3):
			n.draw_rect(Rect2(1492, GameData.FLOOR_Y - 55.0 + float(ci) * 18.0, 26, 14),
				Color(0.50, 0.28, 0.20))
		# Delivery box (Day 3 target)
		if GameState.current_day >= 3:
			n.draw_rect(Rect2(1560, GameData.FLOOR_Y - 74, 28, 20), Color(0.60, 0.52, 0.30))
			n.draw_rect(Rect2(1561, GameData.FLOOR_Y - 74, 26, 2), Color(0.50, 0.42, 0.22))
			n.draw_rect(Rect2(1560, GameData.FLOOR_Y - 74, 2, 20), Color(0.50, 0.42, 0.22))
			n.draw_rect(Rect2(1586, GameData.FLOOR_Y - 74, 2, 20), Color(0.50, 0.42, 0.22))
		# Index placard on wall
		n.draw_rect(Rect2(20, -80, 80, 50), Color(0.12, 0.14, 0.22))
		n.draw_rect(Rect2(22, -78, 76, 46), Color(0.09, 0.11, 0.18))
		for ly in [6, 16, 26, 36]:
			n.draw_rect(Rect2(28.0, -78.0 + float(ly), 64, 4),
				Color(GameData.COL_OFF_TRIM, 0.4))
		# Small clock on wall
		n.draw_circle(Vector2(1760.0, -150.0), 14.0, Color(0.10, 0.11, 0.18))
		n.draw_circle(Vector2(1760.0, -150.0), 12.0, Color(0.14, 0.15, 0.22))
		n.draw_rect(Rect2(1759, -150, 1, 10), Color(0.70, 0.72, 0.78))  # hand
		n.draw_rect(Rect2(1760, -150, 8, 1), Color(0.70, 0.72, 0.78))   # hand
	layer.add_child(draw_node)

func _build_npcs() -> void:
	if GameState.current_day < 3:
		return
	var npc_script := load("res://scripts/entities/NPC.gd")
	_records_employee = Node2D.new()
	_records_employee.set_script(npc_script)
	_records_employee.position = Vector2(1600, GameData.FLOOR_Y - GameData.BECK_HEIGHT)
	_records_employee.npc_color = Color(0.42, 0.48, 0.55)
	_records_employee.npc_name = "RECORDS EMPLOYEE"
	_records_employee.walking = false
	_records_employee.dialogue_lines = Dialogue.RECORDS_EMPLOYEE_DAY3
	add_child(_records_employee)

func _build_exits() -> void:
	# Elevator exit (left — back to office floor)
	var elev_trigger := Area2D.new()
	var en := CollisionShape2D.new()
	var es := RectangleShape2D.new()
	es.size = Vector2(40, 200)
	en.shape = es
	elev_trigger.add_child(en)
	elev_trigger.position = Vector2(30.0, GameData.FLOOR_Y - 100.0)
	elev_trigger.body_entered.connect(func(body):
		if body == beck:
			SceneManager.transition_to(GameData.SceneID.ELEVATOR, 0.5))
	add_child(elev_trigger)

	# Day 3: delivery interactable at desk
	if GameState.current_day >= 3:
		var int_script := load("res://scripts/entities/InteractableObject.gd")
		var delivery_obj := Node2D.new()
		delivery_obj.set_script(int_script)
		delivery_obj.position = Vector2(1575, GameData.FLOOR_Y - 70)
		delivery_obj.object_name = "Delivery Packet"
		delivery_obj.dialogue_lines = Dialogue.HALLWAY_ODDITY_DAY3
		delivery_obj.connect("interacted", _on_delivery_interact)
		add_child(delivery_obj)

func _on_delivery_interact(_obj: Node) -> void:
	GameState.set_flag("delivery_done", true)
	DialogueManager.start_sequence(Dialogue.TASK_COMPLETE_DAY1)

func _trigger_day3_events() -> void:
	if GameState.current_day == 3 and not GameState.get_flag("records_visited"):
		GameState.set_flag("records_visited", true)

func _build_lighting() -> void:
	# Dim overhead lights — only a few work
	for i in range(4):
		ShadowSystem.add_point_light(self,
			Vector2(200.0 + float(i) * 450.0, GameData.FLOOR_Y - 210),
			Color(0.55, 0.65, 0.90), 0.75, 240, true)
	# Desk lamp at records terminal (green glow)
	ShadowSystem.add_point_light(self,
		Vector2(1650.0, GameData.FLOOR_Y - 80),
		Color(0.30, 0.90, 0.30), 1.1, 80, false)
	# Shelf-edge shadow occluders
	for sx in [60.0, 480.0, 900.0, 1320.0]:
		_wall_occluder(self, sx - 4.0, -172.0, 8.0, 172.0 + GameData.FLOOR_Y)

func _start_ambient() -> void:
	AudioManager.play_ambient_hum()

func get_beck_start_x() -> float:
	return 60.0

func get_bounds() -> Vector2:
	return Vector2(20.0, RECORDS_W - 20.0)
