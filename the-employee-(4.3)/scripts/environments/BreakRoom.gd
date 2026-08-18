extends "res://scripts/environments/BaseEnvironment.gd"

const ROOM_W := 600.0

func _ready() -> void:
	room_right = ROOM_W
	super._ready()

func _build_environment() -> void:
	_build_walls()
	_build_floor()
	_build_furniture()
	_build_npcs()
	_build_exits()

func _build_walls() -> void:
	var layer: Node2D = _layers["mid"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		n.draw_rect(Rect2(-100, -300, ROOM_W + 200, 300 + GameData.FLOOR_Y),
			GameData.COL_OFF_WALL.lightened(0.04))
		n.draw_rect(Rect2(-100, -302, ROOM_W + 200, 40), GameData.COL_OFF_CEIL)
		n.draw_rect(Rect2(-100, GameData.FLOOR_Y - 10, ROOM_W + 200, 10),
			GameData.COL_OFF_WALL.darkened(0.2))
		n.draw_rect(Rect2(-100, GameData.FLOOR_Y - 12, ROOM_W + 200, 2), GameData.COL_OFF_TRIM)
		# Small window
		n.draw_rect(Rect2(80, -180, 70, 80), GameData.COL_OFF_WALL.darkened(0.1))
		n.draw_rect(Rect2(83, -177, 64, 74), Color(0.50, 0.60, 0.75, 0.6))
		n.draw_rect(Rect2(83, -177 + 37, 64, 3), GameData.COL_OFF_WALL.darkened(0.1))
		# Break room sign
		n.draw_rect(Rect2(220, -140, 80, 20), GameData.COL_OFF_WALL.darkened(0.15))
		n.draw_rect(Rect2(222, -138, 76, 16), GameData.COL_OFF_WALL)
		for sy in [4, 10]:
			n.draw_rect(Rect2(230.0, -138.0 + float(sy), 60, 3),
				Color(GameData.COL_OFF_TRIM, 0.5))
	layer.add_child(draw_node)

func _build_floor() -> void:
	var layer: Node2D = _layers["near"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		n.draw_rect(Rect2(-100, GameData.FLOOR_Y, ROOM_W + 200, 200), GameData.COL_OFF_FLOOR.lightened(0.02))
		for tx in range(-100, int(ROOM_W) + 200, 48):
			n.draw_line(Vector2(float(tx), GameData.FLOOR_Y),
				Vector2(float(tx), GameData.FLOOR_Y + 200),
				Color(GameData.COL_OFF_SHADOW, 0.25), 1.0)
	layer.add_child(draw_node)

func _build_furniture() -> void:
	var layer: Node2D = _layers["near"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		# Break room table
		n.draw_rect(Rect2(180, GameData.FLOOR_Y - 50, 200, 50), GameData.COL_OFF_WALL.darkened(0.08))
		n.draw_rect(Rect2(178, GameData.FLOOR_Y - 52, 204, 4), GameData.COL_OFF_TRIM)
		# Chairs around table
		for ci in range(4):
			var cx := 190.0 + float(ci) * 50.0
			n.draw_rect(Rect2(cx, GameData.FLOOR_Y - 24, 40, 24), Color(0.22, 0.24, 0.32))
		# Countertop / kitchenette
		n.draw_rect(Rect2(420, GameData.FLOOR_Y - 60, 160, 60), GameData.COL_OFF_WALL.darkened(0.1))
		n.draw_rect(Rect2(418, GameData.FLOOR_Y - 62, 164, 4), GameData.COL_OFF_TRIM)
		# Coffee machine
		n.draw_rect(Rect2(440, GameData.FLOOR_Y - 90, 30, 32), Color(0.15, 0.16, 0.22))
		n.draw_rect(Rect2(442, GameData.FLOOR_Y - 88, 26, 22), Color(0.08, 0.10, 0.18))
		# Cup
		n.draw_rect(Rect2(456, GameData.FLOOR_Y - 68, 8, 8), Color(0.88, 0.85, 0.78))
		# Microwave
		n.draw_rect(Rect2(490, GameData.FLOOR_Y - 90, 70, 32), Color(0.20, 0.22, 0.28))
		n.draw_rect(Rect2(492, GameData.FLOOR_Y - 88, 50, 28), Color(0.08, 0.10, 0.18))
		n.draw_rect(Rect2(544, GameData.FLOOR_Y - 90, 14, 32), Color(0.25, 0.27, 0.35))
		# Food on table
		n.draw_rect(Rect2(220, GameData.FLOOR_Y - 54, 20, 4), Color(0.75, 0.70, 0.55))
		n.draw_rect(Rect2(260, GameData.FLOOR_Y - 56, 16, 6), Color(0.65, 0.55, 0.42))
	layer.add_child(draw_node)

func _build_npcs() -> void:
	var npc_script := load("res://scripts/entities/NPC.gd")
	# Coworker sitting at table (eating)
	var coworker := Node2D.new()
	coworker.set_script(npc_script)
	coworker.position = Vector2(240, GameData.FLOOR_Y - GameData.BECK_HEIGHT)
	coworker.npc_color = Color(0.45, 0.50, 0.55)
	coworker.npc_name = "COWORKER"
	coworker.walking = false

	match GameState.current_day:
		1: coworker.dialogue_lines = Dialogue.COWORKER_BREAK_DAY1
		2: coworker.dialogue_lines = Dialogue.COWORKER_BREAK_DAY1  # day 2 break room dialogue reuse
		3: coworker.dialogue_lines = Dialogue.COWORKER_BREAK_DAY3
	add_child(coworker)

func _build_exits() -> void:
	var trigger := Area2D.new()
	var sn := CollisionShape2D.new()
	var ss := RectangleShape2D.new()
	ss.size = Vector2(40, 200)
	sn.shape = ss
	trigger.add_child(sn)
	trigger.position = Vector2(30.0, GameData.FLOOR_Y - 100.0)
	trigger.body_entered.connect(func(body): if body == beck: SceneManager.transition_to(GameData.SceneID.OFFICE_FLOOR))
	add_child(trigger)

func _build_lighting() -> void:
	ShadowSystem.add_point_light(self,
		Vector2(ROOM_W / 2.0, GameData.FLOOR_Y - 250),
		Color(0.80, 0.85, 1.00), 1.1, 350, true)
	ShadowSystem.add_point_light(self,
		Vector2(ROOM_W * 0.75, GameData.FLOOR_Y - 200),
		Color(0.85, 0.82, 0.70), 0.8, 200, false)

func _start_ambient() -> void:
	AudioManager.play_ambient_office()

func get_beck_start_x() -> float:
	return 60.0

func get_bounds() -> Vector2:
	return Vector2(10.0, ROOM_W - 10.0)
