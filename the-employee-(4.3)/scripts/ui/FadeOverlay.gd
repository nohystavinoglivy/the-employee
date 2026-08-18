extends CanvasLayer

# ── Full-screen black fade overlay ───────────────────────────────────────────

signal fade_in_done
signal fade_out_done

var _rect: ColorRect = null
var _alpha: float = 1.0

func _ready() -> void:
	layer = 100
	_rect = ColorRect.new()
	_rect.color = Color(0, 0, 0, 1)
	_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_rect)

func fade_in(duration: float = 0.5) -> void:
	_rect.color = Color(0, 0, 0, 1.0)
	_rect.visible = true
	var tween := create_tween()
	tween.tween_method(_set_alpha, 1.0, 0.0, duration)
	await tween.finished
	_rect.visible = false
	fade_in_done.emit()

func fade_out(duration: float = 0.5) -> void:
	_rect.color = Color(0, 0, 0, 0.0)
	_rect.visible = true
	var tween := create_tween()
	tween.tween_method(_set_alpha, 0.0, 1.0, duration)
	await tween.finished
	fade_out_done.emit()

func set_black() -> void:
	_rect.color = Color(0, 0, 0, 1)
	_rect.visible = true

func set_transparent() -> void:
	_rect.color = Color(0, 0, 0, 0)
	_rect.visible = false

func _set_alpha(a: float) -> void:
	_alpha = a
	_rect.color = Color(0, 0, 0, a)
