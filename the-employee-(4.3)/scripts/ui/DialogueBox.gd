extends CanvasLayer

# ── Dialogue Box UI ───────────────────────────────────────────────────────────
# Handles all dialogue display styles: normal, internal, YAX, system.

const STYLE_NORMAL   := "normal"
const STYLE_INTERNAL := "internal"
const STYLE_YAX      := "yax"
const STYLE_SYSTEM   := "system"

var _box_rect: ColorRect = null
var _name_rect: ColorRect = null
var _text_node: Node = null

var _current_style: String = STYLE_NORMAL
var _advance_ready: bool = false
var _blink_timer: float = 0.0

func _ready() -> void:
	layer = 50
	_build_box()
	hide()

func _build_box() -> void:
	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)

	# Main dialogue box
	_box_rect = ColorRect.new()
	_box_rect.size = Vector2(520, 80)
	_box_rect.position = Vector2(60, 260)
	root.add_child(_box_rect)

	# Speaker name box
	_name_rect = ColorRect.new()
	_name_rect.size = Vector2(120, 16)
	_name_rect.position = Vector2(60, 244)
	root.add_child(_name_rect)

	# Text label (WaveTextLabel via script)
	var wave_script := load("res://scripts/ui/WaveTextLabel.gd")
	_text_node = Control.new()
	_text_node.set_script(wave_script)
	_text_node.position = Vector2(68, 268)
	_text_node.size = Vector2(504, 64)
	root.add_child(_text_node)

func _process(delta: float) -> void:
	if visible:
		_blink_timer += delta
		queue_redraw()

func _draw() -> void:
	if not visible:
		return
	# Style-dependent colors applied here via ColorRect (set in show_line)
	# Advance prompt blink
	if _advance_ready:
		var blink := sin(_blink_timer * 6.0) > 0.0
		if blink:
			draw_rect(Rect2(542, 328, 8, 8), Color(1, 1, 1, 0.8))

func show_line(line: Dictionary) -> void:
	show()
	_advance_ready = false
	_current_style = line.get("style", STYLE_NORMAL)
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")

	_apply_style(_current_style)

	_name_rect.visible = speaker.length() > 0
	if speaker.length() > 0:
		# Draw speaker name text on name rect via label
		for child in _name_rect.get_children():
			child.queue_free()
		var lbl := Label.new()
		lbl.text = speaker
		lbl.add_theme_font_size_override("font_size", 7)
		lbl.add_theme_color_override("font_color", Color(1, 1, 1, 0.9))
		lbl.position = Vector2(4, 2)
		_name_rect.add_child(lbl)

	_text_node.wave_enabled = (_current_style == STYLE_YAX)
	_text_node.font_color = _get_text_color(_current_style)
	_text_node.font_size = 8 if _current_style != STYLE_SYSTEM else 7
	_text_node.text = text

func _apply_style(style: String) -> void:
	match style:
		STYLE_NORMAL:
			_box_rect.color = Color(0.05, 0.06, 0.12, 0.92)
			_name_rect.color = Color(0.15, 0.18, 0.35, 0.95)
		STYLE_INTERNAL:
			_box_rect.color = Color(0.08, 0.06, 0.04, 0.88)
			_name_rect.color = Color(0.22, 0.16, 0.08, 0.9)
		STYLE_YAX:
			_box_rect.color = Color(0.03, 0.08, 0.03, 0.94)
			_name_rect.color = Color(0.06, 0.22, 0.06, 0.95)
		STYLE_SYSTEM:
			_box_rect.color = Color(0.02, 0.02, 0.08, 0.95)
			_name_rect.color = Color(0.08, 0.08, 0.22, 0.95)

func _get_text_color(style: String) -> Color:
	match style:
		STYLE_INTERNAL: return Color(0.90, 0.85, 0.70)
		STYLE_YAX:      return Color(0.40, 1.00, 0.40)
		STYLE_SYSTEM:   return Color(0.60, 0.65, 0.90)
		_:              return Color(0.95, 0.94, 0.90)

func skip_typewriter() -> void:
	if _text_node and _text_node.has_method("skip_to_end"):
		_text_node.skip_to_end()

func mark_advance_ready() -> void:
	_advance_ready = true

func dismiss() -> void:
	hide()
	_advance_ready = false
