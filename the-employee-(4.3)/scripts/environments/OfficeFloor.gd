extends "res://scripts/environments/BaseEnvironment.gd"

# ── Office Floor (Workstation Area) ──────────────────────────────────────────
# Cold corporate interior. Beck's workstation. Supervisor. Coworkers.
# This is the "dungeon" starting floor.

const FLOOR_WIDTH := 2800.0

var _supervisor: Node2D = null
var _workstation_interactable: Node2D = null
var _task_active: bool = false
var _save_terminal: Node2D = null

func _ready() -> void:
	room_right = FLOOR_WIDTH
	super._ready()
	_trigger_day_events()

func _build_environment() -> void:
	_build_walls()
	_build_floor()
	_build_workstations()
	_build_supervisor_area()
	_build_exits()
	_build_npcs()

func _build_walls() -> void:
	var layer: Node2D = _layers["mid"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		var FW := FLOOR_WIDTH
		# Wall
		n.draw_rect(Rect2(-200, -600, FW + 400, 600 + GameData.FLOOR_Y), GameData.COL_OFF_WALL)
		# Drop ceiling panels
		var panel_w := 80
		for cx in range(-200, int(FW) + 400, panel_w):
			n.draw_rect(Rect2(float(cx), -320, float(panel_w) - 2, 320 + GameData.FLOOR_Y),
				GameData.COL_OFF_WALL.lightened(0.02))
			# Fluorescent light fixture
			n.draw_rect(Rect2(float(cx) + 4, -322, float(panel_w) - 10, 4),
				Color(0.80, 0.86, 1.0, 0.85))
		# Baseboard
		n.draw_rect(Rect2(-200, GameData.FLOOR_Y - 10, FW + 400, 10), GameData.COL_OFF_WALL.darkened(0.2))
		n.draw_rect(Rect2(-200, GameData.FLOOR_Y - 12, FW + 400, 2), GameData.COL_OFF_TRIM)
		# Corridor divider
		n.draw_rect(Rect2(-200, -50, FW + 400, 4), Color(GameData.COL_OFF_TRIM, 0.3))

		# Company signage on wall
		n.draw_rect(Rect2(200, -200, 160, 40), GameData.COL_OFF_WALL.darkened(0.1))
		n.draw_rect(Rect2(202, -198, 156, 36), GameData.COL_OFF_WALL)
		for sy in [6, 16, 24]:
			n.draw_rect(Rect2(214.0, -198.0 + float(sy), 130, 3), Color(GameData.COL_OFF_TRIM, 0.5))
	layer.add_child(draw_node)

func _build_floor() -> void:
	var layer: Node2D = _layers["near"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		var FW := FLOOR_WIDTH
		n.draw_rect(Rect2(-200, GameData.FLOOR_Y, FW + 400, 200), GameData.COL_OFF_FLOOR)
		# Carpet-like tile pattern
		var tw := 48
		for tx in range(-200, int(FW) + 400, tw):
			n.draw_line(Vector2(float(tx), GameData.FLOOR_Y),
				Vector2(float(tx), GameData.FLOOR_Y + 200),
				Color(GameData.COL_OFF_SHADOW, 0.3), 1.0)
		for ty in range(0, 200, 32):
			n.draw_line(Vector2(-200.0, GameData.FLOOR_Y + float(ty)),
				Vector2(FW + 200.0, GameData.FLOOR_Y + float(ty)),
				Color(GameData.COL_OFF_SHADOW, 0.2), 1.0)
	layer.add_child(draw_node)

func _build_workstations() -> void:
	var layer: Node2D = _layers["near"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		# Row of workstation cubicles
		for i in range(8):
			var wx := 200.0 + float(i) * 300.0
			_draw_workstation(n, wx, i == 0)  # First one is Beck's
	layer.add_child(draw_node)

func _draw_workstation(n: Node2D, x: float, is_beck: bool) -> void:
	var wy := GameData.FLOOR_Y
	# Cubicle partition
	n.draw_rect(Rect2(x - 5, wy - 80, 6, 80), GameData.COL_OFF_WALL.darkened(0.15))
	n.draw_rect(Rect2(x + 140, wy - 80, 6, 80), GameData.COL_OFF_WALL.darkened(0.15))
	# Desk surface
	n.draw_rect(Rect2(x, wy - 55, 140, 55), GameData.COL_OFF_WALL.darkened(0.08))
	n.draw_rect(Rect2(x, wy - 57, 140, 4), GameData.COL_OFF_TRIM.darkened(0.4))
	# Computer monitor
	n.draw_rect(Rect2(x + 40, wy - 90, 60, 40), Color(0.08, 0.10, 0.18))
	n.draw_rect(Rect2(x + 42, wy - 88, 56, 36), Color(0.05, 0.08, 0.20))
	# Monitor screen — display text
	if is_beck:
		for row in range(4):
			n.draw_rect(Rect2(x + 46.0, wy - 84.0 + float(row) * 7.0, 48, 4),
				Color(GameData.COL_OFF_TRIM, 0.5))
	else:
		n.draw_rect(Rect2(x + 44, wy - 86, 52, 32), Color(0.06, 0.10, 0.18))
	# Monitor stand
	n.draw_rect(Rect2(x + 66, wy - 50, 8, 8), Color(0.25, 0.27, 0.32))
	# Keyboard
	n.draw_rect(Rect2(x + 30, wy - 50, 80, 8), Color(0.20, 0.22, 0.28))
	# Papers on desk
	n.draw_rect(Rect2(x + 5, wy - 54, 24, 4), Color(0.88, 0.85, 0.78))
	n.draw_rect(Rect2(x + 7, wy - 58, 20, 4), Color(0.86, 0.83, 0.76))
	# Chair
	n.draw_rect(Rect2(x + 40, wy - 24, 60, 24), Color(0.22, 0.24, 0.32))
	n.draw_rect(Rect2(x + 42, wy - 60, 56, 40), Color(0.22, 0.24, 0.32))

func _build_supervisor_area() -> void:
	var layer: Node2D = _layers["near"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		# Supervisor's slightly elevated / set-apart area
		var sx := 100.0
		n.draw_rect(Rect2(sx, GameData.FLOOR_Y - 70, 100, 70), GameData.COL_OFF_WALL.darkened(0.05))
		n.draw_rect(Rect2(sx, GameData.FLOOR_Y - 72, 100, 4), GameData.COL_OFF_TRIM)
		# Name plate
		n.draw_rect(Rect2(sx + 20, GameData.FLOOR_Y - 66, 60, 10), GameData.COL_GOLD_DARK)
		n.draw_rect(Rect2(sx + 22, GameData.FLOOR_Y - 64, 56, 6), GameData.COL_GOLD)
	layer.add_child(draw_node)

	# Supervisor NPC
	var npc_script := load("res://scripts/entities/NPC.gd")
	_supervisor = Node2D.new()
	_supervisor.set_script(npc_script)
	_supervisor.position = Vector2(150, GameData.FLOOR_Y - GameData.BECK_HEIGHT)
	_supervisor.npc_color = Color(0.30, 0.35, 0.50)
	_supervisor.npc_name = "SUPERVISOR"
	_supervisor.walking = false
	add_child(_supervisor)

func _build_exits() -> void:
	# To lobby (left)
	var lobby_trigger := Area2D.new()
	var sn := CollisionShape2D.new()
	var ss := RectangleShape2D.new()
	ss.size = Vector2(40, 200)
	sn.shape = ss
	lobby_trigger.add_child(sn)
	lobby_trigger.position = Vector2(30.0, GameData.FLOOR_Y - 100.0)
	lobby_trigger.body_entered.connect(func(body): if body == beck: SceneManager.transition_to(GameData.SceneID.OFFICE_LOBBY))
	add_child(lobby_trigger)

	# Elevator (right side)
	var elev_trigger := Area2D.new()
	var en2 := CollisionShape2D.new()
	var es2 := RectangleShape2D.new()
	es2.size = Vector2(40, 200)
	en2.shape = es2
	elev_trigger.add_child(en2)
	elev_trigger.position = Vector2(FLOOR_WIDTH - 60.0, GameData.FLOOR_Y - 100.0)
	elev_trigger.body_entered.connect(func(body): if body == beck: SceneManager.transition_to(GameData.SceneID.ELEVATOR))
	add_child(elev_trigger)

	# Break room (door mid-floor)
	var br_trigger := Area2D.new()
	var bn := CollisionShape2D.new()
	var bs := RectangleShape2D.new()
	bs.size = Vector2(40, 200)
	bn.shape = bs
	br_trigger.add_child(bn)
	br_trigger.position = Vector2(1600.0, GameData.FLOOR_Y - 100.0)
	br_trigger.body_entered.connect(func(body): if body == beck: SceneManager.transition_to(GameData.SceneID.BREAK_ROOM))
	add_child(br_trigger)

	# Save terminal
	var save_script := load("res://scripts/entities/InteractableObject.gd")
	_save_terminal = Node2D.new()
	_save_terminal.set_script(save_script)
	_save_terminal.position = Vector2(1800, GameData.FLOOR_Y - 50)
	_save_terminal.object_name = "Employee Status Terminal"
	_save_terminal.dialogue_lines = Dialogue.SAVE_TERMINAL
	_save_terminal.connect("interacted", _on_save_terminal_interact)
	add_child(_save_terminal)

func _build_npcs() -> void:
	# Coworkers at desks
	var npc_script := load("res://scripts/entities/NPC.gd")
	for i in range(1, 4):
		var coworker := Node2D.new()
		coworker.set_script(npc_script)
		coworker.position = Vector2(200.0 + float(i) * 300.0, GameData.FLOOR_Y - GameData.BECK_HEIGHT)
		coworker.npc_color = Color(0.40 + float(i) * 0.05, 0.42, 0.50)
		coworker.walking = false
		coworker.npc_name = "COWORKER"
		add_child(coworker)

func _on_save_terminal_interact(_obj: Node) -> void:
	# Show YES/NO prompt
	DialogueManager.start_sequence(Dialogue.SAVE_TERMINAL)
	# For prototype: auto-save after showing prompt
	await DialogueManager.all_dialogues_done
	SaveSystem.save_state()

func _trigger_day_events() -> void:
	if not _supervisor:
		return
	match GameState.current_day:
		1:
			_supervisor.dialogue_lines = Dialogue.SUPERVISOR_DAY1
		2:
			_supervisor.dialogue_lines = Dialogue.SUPERVISOR_DAY2
		3:
			_supervisor.dialogue_lines = Dialogue.SUPERVISOR_DAY3

	# Workstation interaction
	if _workstation_interactable == null:
		var int_script := load("res://scripts/entities/InteractableObject.gd")
		_workstation_interactable = Node2D.new()
		_workstation_interactable.set_script(int_script)
		_workstation_interactable.position = Vector2(270, GameData.FLOOR_Y - 60)
		_workstation_interactable.object_name = "Workstation"
		add_child(_workstation_interactable)

func _build_lighting() -> void:
	# Fluorescent overhead grid
	for i in range(7):
		ShadowSystem.add_point_light(self,
			Vector2(200.0 + float(i) * 400.0, GameData.FLOOR_Y - 310),
			Color(0.80, 0.86, 1.00), 1.0, 280, true)
	# Desk lamp on Beck's station
	ShadowSystem.add_point_light(self,
		Vector2(270.0, GameData.FLOOR_Y - 80),
		Color(0.90, 0.92, 1.00), 1.6, 100, false)
	# Cubicle wall occluders
	for i in range(8):
		_wall_occluder(self, 194.0 + float(i) * 300.0, GameData.FLOOR_Y - 82, 8.0, 82.0)
		_wall_occluder(self, 334.0 + float(i) * 300.0, GameData.FLOOR_Y - 82, 8.0, 82.0)

func _start_ambient() -> void:
	AudioManager.play_ambient_office()

func get_beck_start_x() -> float:
	return 60.0
