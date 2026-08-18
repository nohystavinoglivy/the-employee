extends Node2D

# ── Title Screen ──────────────────────────────────────────────────────────────
# Black. Pixelated title. Blinking prompt.

signal enter_pressed

var _blink_timer: float = 0.0
var _blink_visible: bool = true
var _active: bool = true
var _enter_triggered: bool = false

func _ready() -> void:
	z_index = 90

func _process(delta: float) -> void:
	if not _active:
		return
	_blink_timer += delta
	if _blink_timer > 0.5:
		_blink_timer = 0.0
		_blink_visible = not _blink_visible
	queue_redraw()

func _input(event: InputEvent) -> void:
	if not _active or _enter_triggered:
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		_enter_triggered = true
		_active = false
		enter_pressed.emit()

func _draw() -> void:
	var font := ThemeDB.fallback_font
	# Black background
	draw_rect(Rect2(0, 0, GameData.VIEWPORT_W, GameData.VIEWPORT_H), Color(0, 0, 0))

	# Title: "THE EMPLOYEE" — large pixelated
	var title := "THE EMPLOYEE"
	var title_size := 24
	var tw := font.get_string_size(title, HORIZONTAL_ALIGNMENT_LEFT, -1, title_size).x
	draw_string(font, Vector2(GameData.VIEWPORT_W / 2.0 - tw / 2.0, 140), title,
		HORIZONTAL_ALIGNMENT_LEFT, -1, title_size, Color(0.88, 0.86, 0.80))

	# Subtitle underline
	draw_rect(Rect2(GameData.VIEWPORT_W / 2.0 - tw / 2.0, 148,
		tw, 1), Color(GameData.COL_OFF_TRIM, 0.6))

	# Blinking prompt
	if _blink_visible:
		var prompt := "PRESS ENTER TO BEGIN"
		var ps := 7
		var pw := font.get_string_size(prompt, HORIZONTAL_ALIGNMENT_LEFT, -1, ps).x
		draw_string(font, Vector2(GameData.VIEWPORT_W / 2.0 - pw / 2.0, 220), prompt,
			HORIZONTAL_ALIGNMENT_LEFT, -1, ps, Color(0.75, 0.76, 0.80, 0.9))

	# Small version text
	var version := "PROTOTYPE — PART I"
	var vs := 6
	var vw := font.get_string_size(version, HORIZONTAL_ALIGNMENT_LEFT, -1, vs).x
	draw_string(font, Vector2(GameData.VIEWPORT_W / 2.0 - vw / 2.0, 340), version,
		HORIZONTAL_ALIGNMENT_LEFT, -1, vs, Color(0.40, 0.42, 0.50))
