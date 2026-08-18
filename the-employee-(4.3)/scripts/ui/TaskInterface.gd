extends CanvasLayer

# ── Task Interface Mini-game ───────────────────────────────────────────────────
# Day 1: Form sorting (select the correct option)
# Day 2: Inventory records (fill in fields)
# Day 3: Delivery route (select destination)

signal task_completed(day: int)
signal task_failed(day: int)

var _active: bool = false
var _day: int = 1
var _selected: int = 0
var _options: Array[String] = []
var _correct_idx: int = 0
var _phase: int = 0  # 0=prompt 1=result
var _result_text: String = ""
var _result_success: bool = false
var _result_timer: float = 0.0

func _ready() -> void:
	layer = 65
	hide()

func open_task(day: int) -> void:
	_day = day
	_active = true
	_phase = 0
	_selected = 0
	_setup_day(day)
	show()

func _setup_day(day: int) -> void:
	match day:
		1:
			_options = ["FORM A-14 (ORIENTATION)", "FORM B-02 (REQUISITION)", "FORM C-88 (INCIDENT)"]
			_correct_idx = 0
		2:
			_options = ["ASSET: DESK UNIT 4", "ASSET: DESK UNIT 9", "ASSET: SERVER RACK", "SKIP"]
			_correct_idx = 0
		3:
			_options = ["3RD FLOOR — RECORDS", "2ND FLOOR — ARCHIVE", "BASEMENT — STORAGE"]
			_correct_idx = 0

func _process(delta: float) -> void:
	if not _active:
		return
	if _phase == 1:
		_result_timer += delta
		if _result_timer > 2.0:
			_close()
	queue_redraw()

func _input(event: InputEvent) -> void:
	if not _active or _phase == 1:
		return
	if event.is_action_pressed("ui_down"):
		_selected = (_selected + 1) % _options.size()
	elif event.is_action_pressed("ui_up"):
		_selected = (_selected - 1 + _options.size()) % _options.size()
	elif event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		_submit()

func _submit() -> void:
	_phase = 1
	_result_timer = 0.0
	_result_success = _selected == _correct_idx
	_result_text = "CORRECT — TASK LOGGED." if _result_success else "INCORRECT. SEE SUPERVISOR."
	if _result_success:
		task_completed.emit(_day)
	else:
		task_failed.emit(_day)

func _close() -> void:
	_active = false
	hide()

func _draw() -> void:
	var font := ThemeDB.fallback_font
	draw_rect(Rect2(0, 0, GameData.VIEWPORT_W, GameData.VIEWPORT_H), Color(0, 0, 0, 0.80))
	draw_rect(Rect2(60, 40, 520, 280), Color(0.07, 0.08, 0.14))
	draw_rect(Rect2(60, 40, 520, 2), Color(GameData.COL_OFF_TRIM, 0.7))
	draw_rect(Rect2(60, 318, 520, 2), Color(GameData.COL_OFF_TRIM, 0.7))

	var day_titles := ["FORM SORTING — DAY 1", "INVENTORY RECORDS — DAY 2", "DELIVERY ROUTE — DAY 3"]
	var title := day_titles[clampi(_day - 1, 0, 2)]
	var ts := 9
	var tw := font.get_string_size(title, HORIZONTAL_ALIGNMENT_LEFT, -1, ts).x
	draw_string(font, Vector2(320.0 - tw / 2.0, 64), title,
		HORIZONTAL_ALIGNMENT_LEFT, -1, ts, Color(GameData.COL_OFF_TRIM, 0.9))
	draw_rect(Rect2(60, 70, 520, 1), Color(GameData.COL_OFF_TRIM, 0.3))

	var instructions := [
		"Select the correct new-employee form:",
		"Which asset record needs updating?",
		"Where does this delivery packet go?",
	]
	var inst := instructions[clampi(_day - 1, 0, 2)]
	draw_string(font, Vector2(80, 92), inst,
		HORIZONTAL_ALIGNMENT_LEFT, -1, 7, Color(0.70, 0.72, 0.78))

	if _phase == 0:
		for i in range(_options.size()):
			var oy := 112.0 + float(i) * 36.0
			var sel := i == _selected
			if sel:
				draw_rect(Rect2(68, oy - 4, 504, 28), Color(GameData.COL_OFF_TRIM, 0.08))
				draw_rect(Rect2(68, oy + 20, 504, 1), Color(GameData.COL_OFF_TRIM, 0.4))
			var marker := "> " if sel else "  "
			draw_string(font, Vector2(80, oy + 14), marker + _options[i],
				HORIZONTAL_ALIGNMENT_LEFT, -1, 8,
				Color(GameData.COL_OFF_TRIM, 0.95) if sel else Color(0.65, 0.67, 0.72))
		draw_string(font, Vector2(420, 308), "[Z] confirm / [UP/DN]",
			HORIZONTAL_ALIGNMENT_LEFT, -1, 5, Color(0.38, 0.40, 0.48))
	else:
		var rc := Color(0.35, 0.90, 0.35) if _result_success else Color(0.90, 0.35, 0.35)
		var rw := font.get_string_size(_result_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 10).x
		draw_string(font, Vector2(320.0 - rw / 2.0, 190), _result_text,
			HORIZONTAL_ALIGNMENT_LEFT, -1, 10, rc)
