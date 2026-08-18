extends Node2D

# ── Day / Part title card ─────────────────────────────────────────────────────
# Black screen. White text. Fades in, holds, fades out.

signal card_done

var title_text: String = "DAY 1"
var subtitle_text: String = "EMPLOYEE ORIENTATION"
var hold_time: float = 2.0

var _alpha: float = 0.0
var _phase: int = 0  # 0=fade_in 1=hold 2=fade_out 3=done
var _timer: float = 0.0
const FADE_TIME := 0.6

func _ready() -> void:
	z_index = 95

func _process(delta: float) -> void:
	match _phase:
		0:  # fade in
			_timer += delta
			_alpha = clampf(_timer / FADE_TIME, 0.0, 1.0)
			if _timer >= FADE_TIME:
				_phase = 1
				_timer = 0.0
		1:  # hold
			_timer += delta
			if _timer >= hold_time:
				_phase = 2
				_timer = 0.0
		2:  # fade out
			_timer += delta
			_alpha = clampf(1.0 - _timer / FADE_TIME, 0.0, 1.0)
			if _timer >= FADE_TIME:
				_phase = 3
				card_done.emit()
				queue_free()
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(0, 0, GameData.VIEWPORT_W, GameData.VIEWPORT_H), Color(0, 0, 0, _alpha))
	if _alpha < 0.05:
		return
	var font := ThemeDB.fallback_font
	var title_size := 16
	var tw := font.get_string_size(title_text, HORIZONTAL_ALIGNMENT_LEFT, -1, title_size).x
	draw_string(font, Vector2(GameData.VIEWPORT_W / 2.0 - tw / 2.0, 160), title_text,
		HORIZONTAL_ALIGNMENT_LEFT, -1, title_size, Color(0.92, 0.90, 0.85, _alpha))
	var sub_size := 8
	var sw := font.get_string_size(subtitle_text, HORIZONTAL_ALIGNMENT_LEFT, -1, sub_size).x
	draw_string(font, Vector2(GameData.VIEWPORT_W / 2.0 - sw / 2.0, 184), subtitle_text,
		HORIZONTAL_ALIGNMENT_LEFT, -1, sub_size, Color(0.60, 0.62, 0.68, _alpha))
