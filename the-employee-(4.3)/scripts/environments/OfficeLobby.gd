extends "res://scripts/environments/BaseEnvironment.gd"

# ── Office Lobby ──────────────────────────────────────────────────────────────
# Cold, polished, enormous. Corporate-religious visual language.
# Founders' Hallway is immediately to the right.

const LOBBY_WIDTH  := 2000.0
const WALL_H       := 1400.0

func _ready() -> void:
	room_right = LOBBY_WIDTH
	super._ready()

func _build_environment() -> void:
	_build_far_bg()
	_build_walls()
	_build_floor()
	_build_details()
	_build_founders_transition()

func _build_far_bg() -> void:
	var layer: Node2D = _layers["far"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		n.draw_rect(Rect2(-200, -WALL_H, LOBBY_WIDTH + 400, WALL_H + GameData.VIEWPORT_H),
			GameData.COL_OFF_FAR)
		# Subtle vertical gradient stripes — depth impression
		for i in range(0, int(LOBBY_WIDTH), 60):
			var a := 0.02 + 0.01 * sin(float(i) * 0.005)
			n.draw_rect(Rect2(float(i), -WALL_H, 4, WALL_H + GameData.VIEWPORT_H),
				Color(1, 1, 1, a))
	layer.add_child(draw_node)

func _build_walls() -> void:
	var layer: Node2D = _layers["mid"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		var LW := LOBBY_WIDTH
		# Wall surface
		n.draw_rect(Rect2(-200, -WALL_H, LW + 400, WALL_H + GameData.FLOOR_Y),
			GameData.COL_OFF_WALL)
		# Ceiling
		n.draw_rect(Rect2(-200, -WALL_H, LW + 400, 40), GameData.COL_OFF_CEIL)
		# Baseboard gold trim
		n.draw_rect(Rect2(-200, GameData.FLOOR_Y - 16, LW + 400, 16), GameData.COL_OFF_WALL.darkened(0.2))
		n.draw_rect(Rect2(-200, GameData.FLOOR_Y - 20, LW + 400, 4), GameData.COL_OFF_TRIM)
		# Horizontal band molding at mid-height
		n.draw_rect(Rect2(-200, -280, LW + 400, 12), GameData.COL_OFF_WALL.darkened(0.15))
		n.draw_rect(Rect2(-200, -288, LW + 400, 8), GameData.COL_OFF_TRIM)
		# Vertical pilasters (very tall)
		for i in range(-1, 8):
			var px := float(i) * 280.0 - 20.0
			n.draw_rect(Rect2(px, -WALL_H, 20, WALL_H + GameData.FLOOR_Y),
				GameData.COL_OFF_WALL.lightened(0.04))
			n.draw_rect(Rect2(px - 2, GameData.FLOOR_Y - 22, 24, 4), GameData.COL_OFF_TRIM)
			n.draw_rect(Rect2(px - 2, -WALL_H, 24, 6), GameData.COL_OFF_TRIM)

		# Company logo on back wall (large)
		_draw_company_logo(n, LW / 2.0, -400.0, 80.0)

		# Corporate signage panels
		n.draw_rect(Rect2(300, -320, 200, 60), GameData.COL_OFF_WALL.darkened(0.1))
		n.draw_rect(Rect2(303, -317, 194, 54), GameData.COL_OFF_WALL.darkened(0.05))
		for line_y in [8, 18, 28]:
			n.draw_rect(Rect2(320.0, -320.0 + float(line_y), 160, 4),
				Color(GameData.COL_OFF_TRIM, 0.6))

		# Glass panels / windows high up
		for i in range(4):
			n.draw_rect(Rect2(60.0 + float(i) * 480.0, -WALL_H + 60, 120, 200),
				Color(0.25, 0.35, 0.55, 0.55))
			n.draw_rect(Rect2(60.0 + float(i) * 480.0, -WALL_H + 60, 2, 200),
				Color(GameData.COL_OFF_TRIM, 0.4))
			n.draw_rect(Rect2(60.0 + float(i) * 480.0 + 118, -WALL_H + 60, 2, 200),
				Color(GameData.COL_OFF_TRIM, 0.4))
	layer.add_child(draw_node)

func _draw_company_logo(n: Node2D, cx: float, cy: float, size: float) -> void:
	# Outer ring
	for a in range(0, 360, 5):
		var rad := deg_to_rad(float(a))
		var px := cx + cos(rad) * size
		var py := cy + sin(rad) * size
		n.draw_rect(Rect2(px - 2, py - 2, 4, 4), GameData.COL_OFF_TRIM)
	# Inner spokes
	for a in range(0, 360, 60):
		var rad := deg_to_rad(float(a))
		n.draw_line(Vector2(cx, cy),
			Vector2(cx + cos(rad) * size * 0.85, cy + sin(rad) * size * 0.85),
			GameData.COL_OFF_TRIM, 3.0)
	# Center
	n.draw_circle(Vector2(cx, cy), size * 0.2, GameData.COL_OFF_TRIM)
	n.draw_circle(Vector2(cx, cy), size * 0.1, GameData.COL_OFF_WALL)

func _build_floor() -> void:
	var layer: Node2D = _layers["near"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		var LW := LOBBY_WIDTH
		# Polished marble-like floor
		n.draw_rect(Rect2(-200, GameData.FLOOR_Y, LW + 400, 200), GameData.COL_OFF_FLOOR)
		# Tile grid
		var tw := 80
		var th := 40
		for tx in range(-200, int(LW) + 400, tw):
			n.draw_line(Vector2(float(tx), GameData.FLOOR_Y),
				Vector2(float(tx), GameData.FLOOR_Y + 200),
				Color(GameData.COL_OFF_SHADOW, 0.4), 1.0)
		for ty in range(0, 200, th):
			n.draw_line(Vector2(-200.0, GameData.FLOOR_Y + float(ty)),
				Vector2(LW + 200.0, GameData.FLOOR_Y + float(ty)),
				Color(GameData.COL_OFF_SHADOW, 0.35), 1.0)
		# Floor reflection of logo
		n.draw_rect(Rect2(LW / 2.0 - 60.0, GameData.FLOOR_Y + 4, 120, 80),
			Color(GameData.COL_OFF_TRIM, 0.07))
	layer.add_child(draw_node)

func _build_details() -> void:
	var layer: Node2D = _layers["near"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		# Reception desk
		n.draw_rect(Rect2(600, GameData.FLOOR_Y - 55, 200, 55), GameData.COL_OFF_WALL.darkened(0.1))
		n.draw_rect(Rect2(598, GameData.FLOOR_Y - 57, 204, 6), GameData.COL_OFF_TRIM)
		# Desk screen
		n.draw_rect(Rect2(680, GameData.FLOOR_Y - 80, 40, 30), Color(0.15, 0.20, 0.40))
		n.draw_rect(Rect2(682, GameData.FLOOR_Y - 78, 36, 26), Color(0.08, 0.12, 0.30))
		for row in range(3):
			n.draw_rect(Rect2(686.0, GameData.FLOOR_Y - 74.0 + float(row) * 6.0, 28, 3),
				Color(GameData.COL_OFF_TRIM, 0.4))

		# Signage post — "EMPLOYEE ENTRANCE →"
		n.draw_rect(Rect2(100, GameData.FLOOR_Y - 90, 4, 90), Color(0.35, 0.36, 0.40))
		n.draw_rect(Rect2(98, GameData.FLOOR_Y - 92, 100, 20), Color(0.10, 0.13, 0.28))
		n.draw_rect(Rect2(100, GameData.FLOOR_Y - 90, 96, 16), GameData.COL_OFF_TRIM)
		for ty in [4, 10]:
			n.draw_rect(Rect2(106.0, GameData.FLOOR_Y - 90.0 + float(ty), 82, 3),
				Color(0.08, 0.10, 0.20))
	layer.add_child(draw_node)

func _build_founders_transition() -> void:
	# Exit to founders' hallway (right side) — handled by trigger
	var trigger := Area2D.new()
	var shape_node := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(40, 200)
	shape_node.shape = shape
	trigger.add_child(shape_node)
	trigger.position = Vector2(LOBBY_WIDTH - 40.0, GameData.FLOOR_Y - 100.0)
	trigger.body_entered.connect(func(body): if body == beck: SceneManager.transition_to(GameData.SceneID.OFFICE_FLOOR))
	add_child(trigger)

	# Entry from street
	var entry_trigger := Area2D.new()
	var en := CollisionShape2D.new()
	var es := RectangleShape2D.new()
	es.size = Vector2(40, 200)
	en.shape = es
	entry_trigger.add_child(en)
	entry_trigger.position = Vector2(30.0, GameData.FLOOR_Y - 100.0)
	entry_trigger.body_entered.connect(func(body): if body == beck: SceneManager.transition_to(GameData.SceneID.STREET))
	add_child(entry_trigger)

func _build_lighting() -> void:
	# Cold corporate overhead lighting
	for i in range(5):
		ShadowSystem.add_point_light(self,
			Vector2(200.0 + float(i) * 400.0, GameData.FLOOR_Y - 350),
			Color(0.75, 0.82, 1.00), 1.1, 300, true)
	# Pilaster shadow occluders
	for i in range(-1, 8):
		_wall_occluder(self, float(i) * 280.0 - 22.0, -WALL_H, 26.0, WALL_H)

func _start_ambient() -> void:
	AudioManager.play_ambient_office()

func get_beck_start_x() -> float:
	return 80.0
