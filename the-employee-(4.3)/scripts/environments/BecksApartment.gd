extends "res://scripts/environments/BaseEnvironment.gd"

# ── Beck's Apartment ──────────────────────────────────────────────────────────
# Small, lived-in, employee housing. Aggressively ordinary.
# Warm beige/brown palette — sharp contrast with Founders' Hallway.

const APT_WIDTH := 1200.0
const ROOM_SECTIONS := {
	"bedroom":  {"start": 0.0,    "end": 400.0},
	"living":   {"start": 400.0,  "end": 700.0},
	"kitchen":  {"start": 700.0,  "end": 1000.0},
	"entry":    {"start": 1000.0, "end": 1200.0},
}

var _door_interactable: Node = null
var _items_on_desk: bool = false
var _paperwork_present: bool = false

func _ready() -> void:
	room_right = APT_WIDTH
	_paperwork_present = GameState.current_day >= 2
	super._ready()

func _build_environment() -> void:
	_build_far_bg()
	_build_walls()
	_build_floor()
	_build_furniture()
	_build_interactables()

func _build_far_bg() -> void:
	var layer: Node2D = _layers["far"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		# Far wall (exterior view through windows — slightly lighter during morning)
		n.draw_rect(Rect2(-100, -400, APT_WIDTH + 200, 400 + GameData.FLOOR_Y),
			GameData.COL_APT_WALL_FAR)
		# Distant buildings visible through window
		for i in range(3):
			var bx := 120.0 + float(i) * 180.0
			n.draw_rect(Rect2(bx, -300, 80, 200), GameData.COL_BLDG_FAR)
			n.draw_rect(Rect2(bx + 10, -290, 60, 20), Color(0.7, 0.75, 0.85, 0.4))  # window
	layer.add_child(draw_node)

func _build_walls() -> void:
	var layer: Node2D = _layers["mid"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		var W := APT_WIDTH
		# Main wall surface
		n.draw_rect(Rect2(-100, -400, W + 200, 400 + GameData.FLOOR_Y), GameData.COL_APT_WALL)
		# Ceiling
		n.draw_rect(Rect2(-100, -400, W + 200, 60), GameData.COL_APT_CEILING)
		# Baseboard
		n.draw_rect(Rect2(-100, GameData.FLOOR_Y - 10, W + 200, 10), GameData.COL_APT_TRIM)
		# Crown molding
		n.draw_rect(Rect2(-100, -340, W + 200, 8), GameData.COL_APT_TRIM)

		# Bedroom window
		_draw_window(n, 120.0, -200, 80, 100)
		# Living area window
		_draw_window(n, 500.0, -200, 80, 100)

		# Interior door (bedroom → living)
		_draw_door_frame(n, 385.0, GameData.FLOOR_Y - 130)
		# Front door (exit)
		_draw_door_frame(n, 1060.0, GameData.FLOOR_Y - 130, true)

		# Wall decoration — framed schedule/motivational print
		n.draw_rect(Rect2(280, -220, 60, 40), GameData.COL_APT_TRIM)
		n.draw_rect(Rect2(282, -218, 56, 36), Color(0.88, 0.85, 0.78))
		# Tiny text lines in frame
		for line_y in [4, 10, 16, 22]:
			n.draw_rect(Rect2(290.0, -218.0 + float(line_y), 40, 2),
				Color(0.4, 0.38, 0.34, 0.5))
	layer.add_child(draw_node)

func _draw_window(n: Node2D, x: float, y: float, w: float, h: float) -> void:
	# Window frame
	n.draw_rect(Rect2(x - 4, y - 4, w + 8, h + 8), GameData.COL_APT_TRIM)
	# Glass — morning light color
	n.draw_rect(Rect2(x, y, w, h), Color(0.60, 0.72, 0.85, 0.7))
	# Cross bar
	n.draw_rect(Rect2(x, y + h / 2.0 - 1, w, 3), GameData.COL_APT_TRIM)
	n.draw_rect(Rect2(x + w / 2.0 - 1, y, 3, h), GameData.COL_APT_TRIM)
	# Light cast on floor
	n.draw_rect(Rect2(x, GameData.FLOOR_Y, w * 0.8, 30),
		Color(GameData.COL_APT_LIGHT, 0.15))

func _draw_door_frame(n: Node2D, x: float, y: float, is_exit: bool = false) -> void:
	var dw := 40.0
	var dh := 110.0
	n.draw_rect(Rect2(x, y, dw, dh), GameData.COL_APT_TRIM)
	var door_col := Color(0.55, 0.45, 0.32) if not is_exit else Color(0.4, 0.38, 0.32)
	n.draw_rect(Rect2(x + 3, y + 3, dw - 6, dh - 3), door_col)
	# Door handle
	n.draw_rect(Rect2(x + dw - 10, y + dh / 2.0, 6, 3), GameData.COL_APT_TRIM)
	if is_exit:
		# Exit door plaque
		n.draw_rect(Rect2(x + 5, y + 20, dw - 10, 12), Color(0.75, 0.68, 0.52))

func _build_floor() -> void:
	var layer: Node2D = _layers["near"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		var W := APT_WIDTH
		# Wooden plank floor
		n.draw_rect(Rect2(-100, GameData.FLOOR_Y, W + 200, 200), GameData.COL_APT_FLOOR)
		# Plank lines
		var plank_w := 32
		for px in range(-100, int(W) + 200, plank_w):
			n.draw_line(
				Vector2(float(px), GameData.FLOOR_Y),
				Vector2(float(px), GameData.FLOOR_Y + 200),
				Color(GameData.COL_APT_SHADOW, 0.35), 1.0)
		# Horizontal grain lines
		for gy in range(4, 200, 6):
			n.draw_line(
				Vector2(-100.0, GameData.FLOOR_Y + float(gy)),
				Vector2(W + 100.0, GameData.FLOOR_Y + float(gy)),
				Color(GameData.COL_APT_SHADOW, 0.10), 1.0)
		# Small bedroom rug
		n.draw_rect(Rect2(60, GameData.FLOOR_Y + 2, 200, 60),
			Color(0.55, 0.35, 0.28, 0.9))
		n.draw_rect(Rect2(64, GameData.FLOOR_Y + 6, 192, 52),
			Color(0.60, 0.40, 0.30, 0.7))
		# Rug pattern
		for ri in range(3):
			n.draw_rect(Rect2(80.0 + float(ri) * 56.0, GameData.FLOOR_Y + 16, 40, 30),
				Color(0.72, 0.50, 0.35, 0.5))
	layer.add_child(draw_node)

func _build_furniture() -> void:
	var layer: Node2D = _layers["near"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		# ── Bedroom ──────────────────────────────────────────────────────────
		# Bed frame
		n.draw_rect(Rect2(20, GameData.FLOOR_Y - 60, 140, 60), Color(0.42, 0.34, 0.24))
		# Mattress
		n.draw_rect(Rect2(24, GameData.FLOOR_Y - 56, 132, 50), Color(0.82, 0.78, 0.70))
		# Pillow
		n.draw_rect(Rect2(130, GameData.FLOOR_Y - 52, 22, 18), Color(0.92, 0.90, 0.86))
		# Bedside table
		n.draw_rect(Rect2(170, GameData.FLOOR_Y - 42, 32, 42), Color(0.38, 0.30, 0.22))
		n.draw_rect(Rect2(170, GameData.FLOOR_Y - 44, 32, 4), Color(0.45, 0.38, 0.28))
		# Book on nightstand (open)
		n.draw_rect(Rect2(174, GameData.FLOOR_Y - 46, 24, 3), Color(0.88, 0.85, 0.78))
		n.draw_rect(Rect2(185, GameData.FLOOR_Y - 46, 1, 3), Color(0.40, 0.38, 0.34))
		# Lamp on nightstand
		n.draw_rect(Rect2(190, GameData.FLOOR_Y - 60, 8, 16), Color(0.50, 0.44, 0.36))
		n.draw_rect(Rect2(186, GameData.FLOOR_Y - 68, 16, 10), Color(0.90, 0.88, 0.80, 0.85))

		# ── Living area ───────────────────────────────────────────────────────
		# Small couch
		n.draw_rect(Rect2(420, GameData.FLOOR_Y - 50, 100, 50), Color(0.48, 0.42, 0.34))
		n.draw_rect(Rect2(420, GameData.FLOOR_Y - 52, 100, 12), Color(0.52, 0.46, 0.38))
		n.draw_rect(Rect2(418, GameData.FLOOR_Y - 50, 8, 50), Color(0.52, 0.46, 0.38))
		n.draw_rect(Rect2(512, GameData.FLOOR_Y - 50, 8, 50), Color(0.52, 0.46, 0.38))
		# Coffee table
		n.draw_rect(Rect2(440, GameData.FLOOR_Y - 16, 60, 16), Color(0.38, 0.30, 0.22))
		# Cup on table
		n.draw_rect(Rect2(462, GameData.FLOOR_Y - 24, 8, 8), Color(0.60, 0.55, 0.48))

		# ── Kitchen ──────────────────────────────────────────────────────────
		n.draw_rect(Rect2(710, GameData.FLOOR_Y - 70, 260, 70), Color(0.32, 0.28, 0.22))
		n.draw_rect(Rect2(710, GameData.FLOOR_Y - 72, 260, 5), Color(0.48, 0.42, 0.34))
		# Sink
		n.draw_rect(Rect2(800, GameData.FLOOR_Y - 68, 50, 40), Color(0.65, 0.62, 0.58))
		n.draw_rect(Rect2(803, GameData.FLOOR_Y - 65, 44, 34), Color(0.48, 0.46, 0.50))
		# Faucet
		n.draw_rect(Rect2(820, GameData.FLOOR_Y - 80, 4, 16), Color(0.65, 0.62, 0.58))
		# Cabinets above
		n.draw_rect(Rect2(710, GameData.FLOOR_Y - 180, 260, 80), Color(0.45, 0.38, 0.28))
		for c in range(3):
			n.draw_rect(Rect2(714.0 + float(c) * 88.0, GameData.FLOOR_Y - 176, 82, 72),
				Color(0.52, 0.44, 0.32))

		# ── Desk in bedroom ───────────────────────────────────────────────────
		n.draw_rect(Rect2(220, GameData.FLOOR_Y - 50, 100, 50), Color(0.38, 0.30, 0.22))
		n.draw_rect(Rect2(220, GameData.FLOOR_Y - 52, 100, 5), Color(0.48, 0.40, 0.30))
		# Papers on desk
		n.draw_rect(Rect2(228, GameData.FLOOR_Y - 56, 30, 4), Color(0.90, 0.88, 0.82))
		n.draw_rect(Rect2(232, GameData.FLOOR_Y - 60, 26, 4), Color(0.88, 0.85, 0.78))
		# Strange paperwork (day 2+)
		if _paperwork_present:
			n.draw_rect(Rect2(280, GameData.FLOOR_Y - 56, 28, 4), Color(0.88, 0.85, 0.78))
			# The symbol — an eye-like glyph
			n.draw_rect(Rect2(287, GameData.FLOOR_Y - 54, 14, 2), Color(0.22, 0.24, 0.38))
			n.draw_circle(Vector2(294, GameData.FLOOR_Y - 55.0), 3.0, Color(0.22, 0.24, 0.38))
			n.draw_circle(Vector2(294, GameData.FLOOR_Y - 55.0), 1.5, Color(0.90, 0.85, 0.72))
	layer.add_child(draw_node)

func _build_interactables() -> void:
	# Nightstand / book
	var nightstand := _make_interactable(Vector2(186, GameData.FLOOR_Y - 44), "Nightstand",
		Dialogue.NIGHTSTAND if GameState.current_day == 1 else [])
	# Table
	var table := _make_interactable(Vector2(462, GameData.FLOOR_Y - 20), "Table",
		Dialogue.TABLE)
	# Cup
	var cup := _make_interactable(Vector2(466, GameData.FLOOR_Y - 22), "Cup",
		Dialogue.CUP)
	# Door (exit — blocked until name given)
	_door_interactable = _make_interactable(Vector2(1060, GameData.FLOOR_Y - 65), "Front Door",
		Dialogue.DOOR_BLOCKED)
	_door_interactable.connect("interacted", _on_door_interact)

	# Paperwork (day 2+)
	if _paperwork_present:
		var pw := _make_interactable(Vector2(294, GameData.FLOOR_Y - 54), "Document",
			Dialogue.PAPERWORK_DAY2)

func _make_interactable(pos: Vector2, obj_name: String, lines: Array) -> Node2D:
	var script := load("res://scripts/entities/InteractableObject.gd")
	var obj := Node2D.new()
	obj.set_script(script)
	obj.position = pos
	obj.object_name = obj_name
	obj.dialogue_lines = lines
	add_child(obj)
	_interactables.append(obj)
	return obj

func _on_door_interact(_obj: Node) -> void:
	if GameState.get_flag("name_given"):
		_exit_apartment()
	else:
		DialogueManager.start_sequence(Dialogue.DOOR_BLOCKED)

func _exit_apartment() -> void:
	SceneManager.transition_to(GameData.SceneID.STREET, 0.5)

func _build_lighting() -> void:
	# Warm ceiling light
	ShadowSystem.add_point_light(self,
		Vector2(200, GameData.FLOOR_Y - 200),
		GameData.COL_APT_LIGHT, 1.2, 250, true)
	ShadowSystem.add_point_light(self,
		Vector2(600, GameData.FLOOR_Y - 200),
		GameData.COL_APT_LIGHT, 1.0, 220, true)
	ShadowSystem.add_point_light(self,
		Vector2(850, GameData.FLOOR_Y - 200),
		Color(0.95, 0.88, 0.65), 0.9, 200, true)
	# Bed lamp (warm)
	ShadowSystem.add_point_light(self,
		Vector2(194, GameData.FLOOR_Y - 62),
		Color(1.0, 0.88, 0.60), 1.8, 80, false)

	# Occluders for walls
	_wall_occluder(self, -100, -400, 20, 400 + GameData.FLOOR_Y)
	_wall_occluder(self, APT_WIDTH - 20, -400, 20, 400 + GameData.FLOOR_Y)

func _start_ambient() -> void:
	AudioManager.play_ambient_hum()

func get_beck_start_x() -> float:
	return 80.0

func get_bounds() -> Vector2:
	return Vector2(10.0, APT_WIDTH - 20.0)
