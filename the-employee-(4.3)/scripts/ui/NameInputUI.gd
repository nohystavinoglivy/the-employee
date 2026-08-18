extends CanvasLayer

# ── Name Input UI ─────────────────────────────────────────────────────────────
# Player types a name for Chakekix. Pixelated text input.

signal name_submitted(player_name: String)

var _input_text: String = ""
var _blink_timer: float = 0.0
var _blink_on: bool = true
var _active: bool = false

const MAX_CHARS := 12

func _ready() -> void:
	layer = 70
	hide()

func activate() -> void:
	_active = true
	_input_text = ""
	show()
	set_process_input(true)

func deactivate() -> void:
	_active = false
	hide()
	set_process_input(false)

func _process(delta: float) -> void:
	if not _active:
		return
	_blink_timer += delta
	if _blink_timer > 0.45:
		_blink_timer = 0.0
		_blink_on = not _blink_on
	queue_redraw()

func _input(event: InputEvent) -> void:
	if not _active:
		return
	if event is InputEventKey and event.pressed:
		var key := event.keycode
		if key == KEY_BACKSPACE and _input_text.length() > 0:
			_input_text = _input_text.substr(0, _input_text.length() - 1)
		elif key == KEY_ENTER or key == KEY_KP_ENTER:
			if _input_text.length() > 0:
				_on_submit()
		elif key >= KEY_A and key <= KEY_Z:
			if _input_text.length() < MAX_CHARS:
				var ch := String.chr(key)
				_input_text += ch if event.shift_pressed else ch.to_lower()
		elif key == KEY_SPACE and _input_text.length() < MAX_CHARS:
			_input_text += " "

func _on_submit() -> void:
	var name_val := _input_text.strip_edges()
	if name_val.length() == 0:
		return
	GameState.set_player_name(name_val)
	deactivate()
	name_submitted.emit(name_val)

func _draw() -> void:
	var font := ThemeDB.fallback_font
	draw_rect(Rect2(0, 0, GameData.VIEWPORT_W, GameData.VIEWPORT_H), Color(0, 0, 0, 0.85))
	# Panel
	draw_rect(Rect2(100, 120, 440, 120), Color(0.06, 0.07, 0.13))
	draw_rect(Rect2(100, 120, 440, 1), Color(GameData.COL_OFF_TRIM, 0.7))
	draw_rect(Rect2(100, 239, 440, 1), Color(GameData.COL_OFF_TRIM, 0.7))
	draw_rect(Rect2(100, 120, 1, 120), Color(GameData.COL_OFF_TRIM, 0.7))
	draw_rect(Rect2(539, 120, 1, 120), Color(GameData.COL_OFF_TRIM, 0.7))

	var prompt := "WHAT IS ITS NAME?"
	var ps := 9
	var pw := font.get_string_size(prompt, HORIZONTAL_ALIGNMENT_LEFT, -1, ps).x
	draw_string(font, Vector2(320.0 - pw / 2.0, 148), prompt,
		HORIZONTAL_ALIGNMENT_LEFT, -1, ps, Color(0.88, 0.86, 0.80))

	# Input field
	draw_rect(Rect2(140, 162, 360, 20), Color(0.04, 0.05, 0.10))
	draw_rect(Rect2(140, 162, 360, 1), Color(GameData.COL_OFF_TRIM, 0.5))
	draw_rect(Rect2(140, 181, 360, 1), Color(GameData.COL_OFF_TRIM, 0.5))
	var input_display := _input_text
	var tw := font.get_string_size(input_display, HORIZONTAL_ALIGNMENT_LEFT, -1, 8).x
	draw_string(font, Vector2(148, 177), input_display,
		HORIZONTAL_ALIGNMENT_LEFT, -1, 8, Color(0.40, 1.0, 0.40))
	# Cursor blink
	if _blink_on:
		draw_rect(Rect2(150.0 + tw, 163, 2, 16), Color(0.40, 1.0, 0.40, 0.9))

	draw_string(font, Vector2(230, 206), "[ENTER] to confirm",
		HORIZONTAL_ALIGNMENT_LEFT, -1, 6, Color(0.50, 0.52, 0.58))
