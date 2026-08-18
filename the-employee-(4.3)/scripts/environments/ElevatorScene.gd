extends "res://scripts/environments/BaseEnvironment.gd"

# ── Elevator ──────────────────────────────────────────────────────────────────
# Faux-3D transition. Beck remains centered.
# Floor indicators change. Lighting shifts. Distant geometry shifts.

const ELEV_W := 640.0

var _current_floor: int = 1
var _target_floor: int = 1
var _floor_label: String = "1"
var _travel_time: float = 0.0
var _is_traveling: bool = false
var _door_state: float = 0.0  # 0=open, 1=closed

var _floor_indicator_node: Node2D = null

func _ready() -> void:
	room_right = ELEV_W
	_current_floor = 1
	_target_floor = 3 if GameState.current_day >= 3 else 1
	super._ready()
	if _target_floor != _current_floor:
		_start_travel(_target_floor)

func _build_environment() -> void:
	_build_elevator_interior()
	_build_floor_indicator()
	_build_doors()

func _build_elevator_interior() -> void:
	var layer: Node2D = _layers["mid"]
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		var EW := ELEV_W
		# Elevator walls — polished metal
		n.draw_rect(Rect2(-200, -400, EW + 400, 400 + GameData.FLOOR_Y), GameData.COL_OFF_WALL.lightened(0.08))
		# Side walls (faux-3D depth via darker panels)
		n.draw_rect(Rect2(-200, -400, 80, 400 + GameData.FLOOR_Y), GameData.COL_OFF_WALL)
		n.draw_rect(Rect2(EW + 120, -400, 80, 400 + GameData.FLOOR_Y), GameData.COL_OFF_WALL)
		# Handrail
		n.draw_rect(Rect2(-100, -80, EW + 200, 6), Color(0.55, 0.58, 0.65))
		# Ceiling
		n.draw_rect(Rect2(-200, -400, EW + 400, 50), GameData.COL_OFF_CEIL)
		# Floor
		n.draw_rect(Rect2(-200, GameData.FLOOR_Y, EW + 400, 200), GameData.COL_OFF_FLOOR.lightened(0.04))
		# Tile lines
		for tx in range(-200, int(EW) + 400, 40):
			n.draw_line(Vector2(float(tx), GameData.FLOOR_Y),
				Vector2(float(tx), GameData.FLOOR_Y + 80),
				Color(GameData.COL_OFF_SHADOW, 0.3), 1.0)
		# Gold trim strips
		n.draw_rect(Rect2(-200, GameData.FLOOR_Y - 8, EW + 400, 4), GameData.COL_OFF_TRIM)
		n.draw_rect(Rect2(-200, -396, EW + 400, 4), GameData.COL_OFF_TRIM)
		# Door frame
		var dx := EW / 2.0 - 60.0
		n.draw_rect(Rect2(dx - 4, -300, 4, 300 + GameData.FLOOR_Y), GameData.COL_OFF_TRIM)
		n.draw_rect(Rect2(dx + 124, -300, 4, 300 + GameData.FLOOR_Y), GameData.COL_OFF_TRIM)
		n.draw_rect(Rect2(dx - 4, -302, 132, 4), GameData.COL_OFF_TRIM)
	layer.add_child(draw_node)

func _build_floor_indicator() -> void:
	var layer: Node2D = _layers["near"]
	var self_ref := self
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		# Floor indicator panel
		var px := ELEV_W / 2.0
		var py := -340.0
		n.draw_rect(Rect2(px - 40, py, 80, 30), Color(0.08, 0.10, 0.18))
		n.draw_rect(Rect2(px - 38, py + 2, 76, 26), Color(0.04, 0.06, 0.14))
		# Current floor number (large)
		var font := ThemeDB.fallback_font
		var floor_str := self_ref._floor_label
		var ts := font.get_string_size(floor_str, HORIZONTAL_ALIGNMENT_CENTER, -1, 18)
		n.draw_string(font, Vector2(px - ts.x / 2.0, py + 22), floor_str, HORIZONTAL_ALIGNMENT_LEFT, -1, 18,
			Color(GameData.COL_OFF_TRIM, 0.9))
		# Floor dots
		for f in range(1, 5):
			var lit := f == self_ref._current_floor
			var dc := GameData.COL_OFF_TRIM if lit else Color(GameData.COL_OFF_TRIM, 0.2)
			n.draw_circle(Vector2(px - 24.0 + float(f - 1) * 16.0, py + 36), 4.0, dc)

		# Button panel
		n.draw_rect(Rect2(ELEV_W - 80.0, GameData.FLOOR_Y - 120, 50, 80),
			Color(0.12, 0.14, 0.22))
		for btn in range(4):
			var blit := btn + 1 == self_ref._target_floor
			var bc := GameData.COL_OFF_TRIM if blit else Color(GameData.COL_OFF_TRIM, 0.25)
			n.draw_rect(Rect2(ELEV_W - 72.0, GameData.FLOOR_Y - 112.0 + float(btn) * 18.0, 34, 12), bc)
			var fs := font.get_string_size(str(btn + 1), HORIZONTAL_ALIGNMENT_LEFT, -1, 7)
			n.draw_string(font, Vector2(ELEV_W - 72.0 + 14.0 - fs.x / 2.0,
				GameData.FLOOR_Y - 112.0 + float(btn) * 18.0 + 10.0),
				str(btn + 1), HORIZONTAL_ALIGNMENT_LEFT, -1, 7,
				Color(0.04, 0.06, 0.14) if blit else Color(GameData.COL_OFF_TRIM, 0.6))
	layer.add_child(draw_node)
	_floor_indicator_node = draw_node

func _build_doors() -> void:
	var layer: Node2D = _layers["fg"]
	var self_ref := self
	var draw_node := _DrawNode.new()
	draw_node.draw_func = func(n: Node2D) -> void:
		# Sliding doors
		var dx := ELEV_W / 2.0 - 60.0
		var door_open := self_ref._door_state
		var slide := door_open * 60.0  # slide amount
		# Left door panel
		n.draw_rect(Rect2(dx - slide, -300, 60, 300 + GameData.FLOOR_Y),
			GameData.COL_OFF_WALL.lightened(0.12))
		n.draw_rect(Rect2(dx - slide + 56, -300, 4, 300 + GameData.FLOOR_Y),
			GameData.COL_OFF_TRIM)
		# Right door panel
		n.draw_rect(Rect2(dx + 64 + slide, -300, 60, 300 + GameData.FLOOR_Y),
			GameData.COL_OFF_WALL.lightened(0.12))
		n.draw_rect(Rect2(dx + 64 + slide, -300, 4, 300 + GameData.FLOOR_Y),
			GameData.COL_OFF_TRIM)
	layer.add_child(draw_node)

func _process(delta: float) -> void:
	if _is_traveling:
		_travel_time += delta
		# Animate floor counter
		var progress := clampf(_travel_time / 2.5, 0.0, 1.0)
		var current_f := lerpf(float(_current_floor), float(_target_floor), progress)
		_floor_label = str(roundi(current_f))
		if _floor_indicator_node:
			_floor_indicator_node.queue_redraw()
		for layer in _layers.values():
			if layer is ParallaxLayer:
				for child in layer.get_children():
					if child.has_method("queue_redraw"):
						child.queue_redraw()
		if _travel_time >= 2.5:
			_is_traveling = false
			_current_floor = _target_floor
			_floor_label = str(_current_floor)
			_on_arrival()

func _start_travel(target: int) -> void:
	_target_floor = target
	_is_traveling = true
	_travel_time = 0.0
	# Close doors
	var tween := create_tween()
	tween.tween_property(self, "_door_state", 1.0, 0.4)
	await tween.finished
	# Open doors after arriving
	await get_tree().create_timer(2.5).timeout
	var tween2 := create_tween()
	tween2.tween_property(self, "_door_state", 0.0, 0.4)

func _on_arrival() -> void:
	if _target_floor == 3:
		SceneManager.transition_to(GameData.SceneID.RECORDS_AREA, 0.5)
	else:
		SceneManager.transition_to(GameData.SceneID.OFFICE_FLOOR, 0.5)

func _build_lighting() -> void:
	ShadowSystem.add_point_light(self,
		Vector2(ELEV_W / 2.0, GameData.FLOOR_Y - 320),
		Color(0.75, 0.82, 1.00), 1.2, 400, false)

func _start_ambient() -> void:
	AudioManager.play_ambient_hum()

func get_beck_start_x() -> float:
	return ELEV_W / 2.0 - 4.0

func get_bounds() -> Vector2:
	return Vector2(ELEV_W * 0.1, ELEV_W * 0.9)
