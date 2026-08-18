class_name ShadowSystem

# ── Light texture generation ──────────────────────────────────────────────────

static func create_light_texture(radius: int = 128, falloff: float = 2.0) -> ImageTexture:
	var img := Image.create(radius * 2, radius * 2, false, Image.FORMAT_RGBA8)
	var center := Vector2(radius, radius)
	for y in range(radius * 2):
		for x in range(radius * 2):
			var dist := Vector2(x, y).distance_to(center) / float(radius)
			var alpha := pow(clampf(1.0 - dist, 0.0, 1.0), falloff)
			img.set_pixel(x, y, Color(1.0, 1.0, 1.0, alpha))
	return ImageTexture.create_from_image(img)

static func create_narrow_light_texture(w: int = 32, h: int = 256) -> ImageTexture:
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	for y in range(h):
		for x in range(w):
			var dist_x := absf(float(x) - float(w) / 2.0) / (float(w) / 2.0)
			var dist_y := float(y) / float(h)
			var alpha := pow(clampf(1.0 - dist_x, 0.0, 1.0), 2.0) * pow(clampf(1.0 - dist_y, 0.0, 1.0), 0.5)
			img.set_pixel(x, y, Color(1.0, 1.0, 1.0, alpha))
	return ImageTexture.create_from_image(img)

# ── Add a PointLight2D to a parent node ──────────────────────────────────────

static func add_point_light(
	parent: Node2D,
	pos: Vector2,
	color: Color = Color.WHITE,
	energy: float = 1.0,
	radius: int = 128,
	shadows: bool = true
) -> PointLight2D:
	var light := PointLight2D.new()
	light.texture = create_light_texture(radius)
	light.texture_scale = float(radius) / 64.0
	light.color = color
	light.energy = energy
	light.shadow_enabled = shadows
	light.shadow_color = Color(0.0, 0.0, 0.0, 0.6)
	light.position = pos
	parent.add_child(light)
	return light

# ── Add a LightOccluder2D (wall/object that blocks light) ────────────────────

static func add_occluder(parent: Node2D, polygon: PackedVector2Array, pos: Vector2 = Vector2.ZERO) -> LightOccluder2D:
	var occluder := LightOccluder2D.new()
	var poly := OccluderPolygon2D.new()
	poly.polygon = polygon
	poly.cull_mode = OccluderPolygon2D.CULL_DISABLED
	occluder.occluder = poly
	occluder.position = pos
	parent.add_child(occluder)
	return occluder

static func add_rect_occluder(parent: Node2D, rect: Rect2) -> LightOccluder2D:
	var pts := PackedVector2Array([
		rect.position,
		Vector2(rect.end.x, rect.position.y),
		rect.end,
		Vector2(rect.position.x, rect.end.y),
	])
	return add_occluder(parent, pts)

# ── Floor blob shadow under a character ──────────────────────────────────────

static func create_blob_shadow(size: Vector2 = Vector2(20, 6)) -> Node2D:
	var node := Node2D.new()
	node.set_script(preload("res://scripts/systems/BlobShadow.gd"))
	node.set_meta("shadow_size", size)
	return node

# ── Directional wall lamp shadow (downward cone) ─────────────────────────────

static func add_wall_lamp(parent: Node2D, pos: Vector2, color: Color, energy: float = 1.5) -> PointLight2D:
	var light := PointLight2D.new()
	light.texture = create_narrow_light_texture(64, 200)
	light.texture_scale = 3.0
	light.color = color
	light.energy = energy
	light.shadow_enabled = true
	light.shadow_color = Color(0.0, 0.0, 0.08, 0.75)
	light.position = pos
	parent.add_child(light)
	return light
