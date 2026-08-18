extends Node2D

var shadow_size: Vector2 = Vector2(20, 6)
var shadow_alpha: float = 0.55
var shadow_color: Color = Color(0.0, 0.0, 0.0, 0.55)

func _ready() -> void:
	if has_meta("shadow_size"):
		shadow_size = get_meta("shadow_size")
	z_index = -1

func _draw() -> void:
	var c := shadow_color
	c.a = shadow_alpha
	draw_ellipse(Vector2.ZERO, shadow_size, c)

func draw_ellipse(center: Vector2, size: Vector2, color: Color) -> void:
	var pts := PackedVector2Array()
	var segments := 16
	for i in range(segments):
		var angle := TAU * float(i) / float(segments)
		pts.append(center + Vector2(cos(angle) * size.x, sin(angle) * size.y))
	draw_colored_polygon(pts, PackedColorArray([color]))

func set_shadow_alpha(a: float) -> void:
	shadow_alpha = a
	queue_redraw()
