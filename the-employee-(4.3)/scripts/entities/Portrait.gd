extends Node2D

@export var founder_name: String = "Thomas Hargrove"
@export var frame_width: int = 48
@export var frame_height: int = 64
@export var is_central: bool = false
@export var portrait_index: int = 0

signal creature_emerged()

var _animate: bool = false
var _emerge: bool = false
var _anim_time: float = 0.0
var _choppy_timer: float = 0.0
var _choppy_offset: Vector2 = Vector2.ZERO
var _choppy_interval: float = 0.15
var _creature_y_offset: float = 0.0
var _eye_shift: bool = false
var _eye_timer: float = 0.0
var _idle_still_timer: float = 0.0
const EMERGE_SPEED := 12.0

func _ready() -> void:
	z_index = 2

func _process(delta: float) -> void:
	_idle_still_timer += delta

	if _animate:
		_anim_time += delta
		_choppy_timer += delta
		if _choppy_timer >= _choppy_interval:
			_choppy_timer = 0.0
			_choppy_interval = randf_range(0.1, 0.22)
			_choppy_offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 0.5))

	if _emerge:
		_creature_y_offset = move_toward(_creature_y_offset, -float(frame_height) * 0.35, EMERGE_SPEED * delta)

	# Eye micro-effect: if player stands still long enough
	if not _emerge and is_central:
		_eye_timer += delta
		if _eye_timer > 8.0:
			_eye_shift = not _eye_shift
			_eye_timer = 0.0

	queue_redraw()

func _draw() -> void:
	var fw := float(frame_width)
	var fh := float(frame_height)
	var ox := -fw / 2.0
	var oy := -fh

	# ── Gold frame ────────────────────────────────────────────────────────────
	var frame_thick := 4 if not is_central else 6
	var fc := GameData.COL_GOLD
	var fd := GameData.COL_GOLD_DARK
	var fh2 := GameData.COL_GOLD_HILIGHT

	# Outer frame
	draw_rect(Rect2(ox - frame_thick, oy - frame_thick,
		fw + frame_thick * 2, fh + frame_thick * 2), fd)
	# Inner highlight
	draw_rect(Rect2(ox - frame_thick + 1, oy - frame_thick + 1,
		fw + frame_thick * 2 - 2, fh + frame_thick * 2 - 2), fc)
	# Top highlight
	draw_rect(Rect2(ox - frame_thick + 1, oy - frame_thick + 1,
		fw + frame_thick * 2 - 2, 2), fh2)

	# Corner ornaments
	_draw_corner(ox - frame_thick, oy - frame_thick, false, false, fc, fd)
	_draw_corner(ox + fw, oy - frame_thick, true, false, fc, fd)
	_draw_corner(ox - frame_thick, oy + fh, false, true, fc, fd)
	_draw_corner(ox + fw, oy + fh, true, true, fc, fd)

	# ── Portrait background ───────────────────────────────────────────────────
	draw_rect(Rect2(ox, oy, fw, fh), GameData.COL_HALL_BG.darkened(0.3))

	# ── Creature figure inside painting ──────────────────────────────────────
	_draw_creature(ox, oy, fw, fh)

	# ── Gold plaque below frame ───────────────────────────────────────────────
	if is_central or portrait_index < 4:
		_draw_plaque(ox, fh / 2.0 + 4.0)

func _draw_corner(cx: float, cy: float, flip_x: bool, flip_y: bool, c: Color, d: Color) -> void:
	var sx := -1.0 if flip_x else 1.0
	var sy := -1.0 if flip_y else 1.0
	draw_rect(Rect2(cx - 1 * (1 - int(flip_x)), cy - 1 * (1 - int(flip_y)), 5, 5), d)
	draw_rect(Rect2(cx, cy, 3 * sx, 3 * sy), c)

func _draw_creature(ox: float, oy: float, fw: float, fh: float) -> void:
	var cx := ox + fw / 2.0
	var base_y := oy + fh * 0.85

	# Apply choppy animation offset
	var anim_ox := _choppy_offset.x if _animate else 0.0
	var anim_oy := _choppy_offset.y if _animate else 0.0
	var emerge_y := _creature_y_offset

	# Body colors — inhuman beings with corporate-formal attire
	var body_dark := Color(0.15, 0.18, 0.28)
	var head_col  := Color(0.55, 0.60, 0.72)
	var eye_col   := Color(0.85, 0.88, 0.95)
	var suit_col  := Color(0.10, 0.12, 0.22)
	var accent    := GameData.COL_GOLD

	# Build a pixel silhouette — tall, formal, slightly wrong
	var bx := cx + anim_ox
	var by := base_y + anim_oy + emerge_y

	# Body silhouette (tall)
	draw_rect(Rect2(bx - 6, by - 36, 12, 24), suit_col)
	# Wide shoulders — inhuman proportion
	draw_rect(Rect2(bx - 9, by - 34, 18, 6), suit_col)
	# Long neck
	draw_rect(Rect2(bx - 2, by - 44, 4, 10), head_col)
	# Head — slightly elongated
	draw_rect(Rect2(bx - 5, by - 60, 10, 16), head_col)
	# Eyes — too high, too wide apart
	var ey := by - 52.0
	var eye_x_l := bx - 5.0 + (2.0 if _eye_shift and is_central else 0.0)
	var eye_x_r := bx + 2.0 + (2.0 if _eye_shift and is_central else 0.0)
	draw_rect(Rect2(eye_x_l, ey, 2, 2), eye_col)
	draw_rect(Rect2(eye_x_r, ey, 2, 2), eye_col)
	# Gold collar insignia
	draw_rect(Rect2(bx - 2, by - 32, 4, 3), accent)
	# Arms
	draw_rect(Rect2(bx - 10, by - 34, 4, 20), suit_col)
	draw_rect(Rect2(bx + 6,  by - 34, 4, 20), suit_col)
	# Hands — long fingers implied
	draw_rect(Rect2(bx - 11, by - 14, 3, 6), head_col)
	draw_rect(Rect2(bx + 8,  by - 14, 3, 6), head_col)

	# If emerging, draw creature extending BELOW portrait frame clip (faux-3D)
	if _emerge and _creature_y_offset < -4.0:
		var ext := absf(_creature_y_offset) * 0.5
		draw_rect(Rect2(bx - 6, oy + fh, 12, ext), suit_col)
		draw_rect(Rect2(bx - 9, oy + fh, 18, 4), suit_col)

func _draw_plaque(ox: float, py: float) -> void:
	var pw := float(frame_width) - 4.0
	draw_rect(Rect2(ox + 2.0, py, pw, 10), GameData.COL_GOLD_DARK)
	draw_rect(Rect2(ox + 3.0, py + 1, pw - 2, 8), GameData.COL_GOLD)

# ── Public methods ────────────────────────────────────────────────────────────

func start_animation() -> void:
	_animate = true
	_idle_still_timer = 0.0

func start_emerge() -> void:
	_emerge = true
	creature_emerged.emit()

func stop_animate() -> void:
	_animate = false
	_choppy_offset = Vector2.ZERO

func interact() -> void:
	DialogueManager.start_sequence(Dialogue.get_portrait_inspect(founder_name))
