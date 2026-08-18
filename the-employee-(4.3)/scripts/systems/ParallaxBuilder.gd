class_name ParallaxBuilder

# Builds a complete ParallaxBackground with multiple layers.
# Each layer is a Node2D that can be drawn via _draw() or populated with children.

static func build(parent: Node2D, room_width: float = 3200.0) -> ParallaxBackground:
	var bg := ParallaxBackground.new()
	bg.name = "ParallaxBG"
	parent.add_child(bg)
	return bg

static func add_layer(
	bg: ParallaxBackground,
	name_str: String,
	scroll_x: float,
	scroll_y: float = 0.0,
	mirror_x: float = 0.0
) -> ParallaxLayer:
	var layer := ParallaxLayer.new()
	layer.name = name_str
	layer.motion_scale = Vector2(scroll_x, scroll_y)
	if mirror_x > 0.0:
		layer.motion_mirroring = Vector2(mirror_x, 0.0)
	bg.add_child(layer)
	return layer

# Convenience: build all 4 standard layers at once
static func build_standard(parent: Node2D, room_width: float = 3200.0) -> Dictionary:
	var bg := build(parent, room_width)
	return {
		"bg":     bg,
		"far":    add_layer(bg, "FarLayer",    GameData.PARALLAX_FAR,  0.0, room_width),
		"mid":    add_layer(bg, "MidLayer",    GameData.PARALLAX_MID,  0.0, room_width),
		"near":   add_layer(bg, "NearLayer",   GameData.PARALLAX_NEAR, 0.0, 0.0),
		"fg":     add_layer(bg, "FGLayer",     GameData.PARALLAX_FG,   0.0, 0.0),
	}
