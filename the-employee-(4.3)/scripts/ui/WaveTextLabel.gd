extends Control

# ── Wave/typewriter text label ────────────────────────────────────────────────
# Typewriter effect with optional per-character sine wave.

signal typewriter_done

var text: String = "" :
	set(v):
		text = v
		_typewriter_index = 0
		_done = false
		_visible_text = ""

var wave_enabled: bool = false
var wave_amplitude: float = 2.0
var wave_speed: float = 4.0
var wave_frequency: float = 0.5
var font_size: int = 8
var font_color: Color = Color(1, 1, 1)

const CHAR_INTERVAL := 0.04

var _typewriter_index: int = 0
var _timer: float = 0.0
var _wave_time: float = 0.0
var _done: bool = false
var _visible_text: String = ""

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(delta: float) -> void:
	_wave_time += delta
	if not _done:
		_timer += delta
		while _timer >= CHAR_INTERVAL and _typewriter_index < text.length():
			_timer -= CHAR_INTERVAL
			_typewriter_index += 1
			_visible_text = text.substr(0, _typewriter_index)
		if _typewriter_index >= text.length() and not _done:
			_done = true
			DialogueManager.on_typewriter_done()
			typewriter_done.emit()
	queue_redraw()

func _draw() -> void:
	var font := ThemeDB.fallback_font
	var x := 0.0
	var y := float(font_size)
	for i in range(_visible_text.length()):
		var ch := _visible_text[i]
		var cy := y
		if wave_enabled:
			cy += sin(_wave_time * wave_speed + float(i) * wave_frequency) * wave_amplitude
		draw_char(font, Vector2(x, cy), ch, font_size, font_color)
		x += font.get_char_size(ch.unicode_at(0), font_size).x

func skip_to_end() -> void:
	_typewriter_index = text.length()
	_visible_text = text
	if not _done:
		_done = true
		DialogueManager.on_typewriter_done()
		typewriter_done.emit()

func is_done() -> bool:
	return _done

func reset() -> void:
	_typewriter_index = 0
	_visible_text = ""
	_done = false
	_timer = 0.0
