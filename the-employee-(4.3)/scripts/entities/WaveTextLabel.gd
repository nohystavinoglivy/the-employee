extends Control

@export var text: String = ""
@export var font_size: int = 8
@export var text_color: Color = Color(0.95, 0.95, 0.92)
@export var wave_active: bool = true
@export var wave_amplitude: float = 2.5
@export var wave_speed: float = 3.5
@export var wave_frequency: float = 0.6

var _wave_time: float = 0.0
var _display_text: String = ""
var _char_positions: Array[float] = []
var _font: Font = null
var _typewriter_index: int = 0
var _typewriter_timer: float = 0.0
var _typewriter_done: bool = false
const CHAR_INTERVAL := 0.04

func _ready() -> void:
	_font = ThemeDB.fallback_font
	if not text.is_empty():
		start_text(text)

func start_text(new_text: String) -> void:
	text = new_text
	_display_text = ""
	_typewriter_index = 0
	_typewriter_timer = 0.0
	_typewriter_done = false
	_build_char_positions()
	custom_minimum_size = Vector2(_measure_text(text), float(font_size) + wave_amplitude * 2.0 + 4.0)

func _build_char_positions() -> void:
	_char_positions.clear()
	var x := 0.0
	for ch in text:
		_char_positions.append(x)
		x += _font.get_char_size(ch.unicode_at(0), font_size).x

func _measure_text(t: String) -> float:
	return _font.get_string_size(t, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x

func _process(delta: float) -> void:
	_wave_time += delta

	if not _typewriter_done:
		_typewriter_timer += delta
		while _typewriter_timer >= CHAR_INTERVAL and _typewriter_index < text.length():
			_typewriter_timer -= CHAR_INTERVAL
			_typewriter_index += 1
			_display_text = text.substr(0, _typewriter_index)
		if _typewriter_index >= text.length():
			_typewriter_done = true
			DialogueManager.on_typewriter_done()

	queue_redraw()

func _draw() -> void:
	if _display_text.is_empty() or _font == null:
		return
	for i in range(_display_text.length()):
		var ch := _display_text[i]
		var base_x := _char_positions[i] if i < _char_positions.size() else 0.0
		var offset_y := sin(_wave_time * wave_speed + float(i) * wave_frequency) * wave_amplitude if wave_active else 0.0
		var pos := Vector2(base_x, float(font_size) + offset_y)
		draw_char(_font, pos, ch, font_size, text_color)

func skip_to_end() -> void:
	_typewriter_index = text.length()
	_display_text = text
	_typewriter_done = true

func is_done() -> bool:
	return _typewriter_done
