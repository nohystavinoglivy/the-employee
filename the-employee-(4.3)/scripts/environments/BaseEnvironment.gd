extends Node2D

# Base class for all game environments.
# Subclasses override _build_environment() and implement specific logic.

var beck: Node2D = null
var camera: Camera2D = null
var _parallax: ParallaxBackground = null
var _layers: Dictionary = {}
var _lights: Array[PointLight2D] = []
var _occluders: Array[LightOccluder2D] = []
var _interactables: Array[Node] = []
var _npcs: Array[Node] = []

const ROOM_LEFT   := -100.0
var   room_right  := 3200.0
const FLOOR_Y     := GameData.FLOOR_Y

func _ready() -> void:
	_build_parallax_layers()
	_build_environment()
	_build_lighting()
	_spawn_beck()
	_setup_camera_limits()
	AudioManager.stop_ambient()
	_start_ambient()

func _build_parallax_layers() -> void:
	_layers = ParallaxBuilder.build_standard(self, room_right)
	_parallax = _layers["bg"]

func _build_environment() -> void:
	pass  # Override in subclass

func _build_lighting() -> void:
	pass  # Override in subclass

func _spawn_beck() -> void:
	var script := load("res://scripts/entities/Beck.gd")
	beck = Node2D.new()
	beck.set_script(script)
	beck.position = Vector2(get_beck_start_x(), FLOOR_Y - GameData.BECK_HEIGHT)
	add_child(beck)
	camera = beck.get_camera()

func _setup_camera_limits() -> void:
	if beck:
		beck.set_camera_limits(ROOM_LEFT, room_right)

func _start_ambient() -> void:
	pass  # Override to play specific ambient

func get_beck_start_x() -> float:
	return 80.0

func get_bounds() -> Vector2:
	return Vector2(ROOM_LEFT + 8, room_right - 8)

# ── Layer drawing helpers ─────────────────────────────────────────────────────

func _add_draw_node(layer: Node, draw_callable: Callable, zidx: int = 0) -> Node2D:
	var node := _DrawNode.new()
	node.draw_func = draw_callable
	node.z_index = zidx
	layer.add_child(node)
	return node

# ── Occluder utilities ────────────────────────────────────────────────────────

func _wall_occluder(parent: Node2D, x: float, y: float, w: float, h: float) -> void:
	ShadowSystem.add_rect_occluder(parent, Rect2(x, y, w, h))

# ── Inner draw node class ─────────────────────────────────────────────────────

class _DrawNode extends Node2D:
	var draw_func: Callable = Callable()
	func _draw() -> void:
		if draw_func.is_valid():
			draw_func.call(self)
