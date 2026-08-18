extends Node2D

signal interaction_requested(interactable: Node)
signal movement_started()
signal movement_stopped()

const WALK_SPEED := GameData.WALK_SPEED
const FLOOR_Y    := GameData.FLOOR_Y
const HEIGHT     := GameData.BECK_HEIGHT

var frozen: bool = false
var facing_right: bool = true
var is_walking: bool = false
var velocity: float = 0.0

var _walk_cycle: float = 0.0
var _nearby_interactable: Node = null
var _interaction_area: Area2D = null
var _camera: Camera2D = null
var _blob_shadow: Node2D = null
var _step_timer: float = 0.0

func _ready() -> void:
	position.y = FLOOR_Y - HEIGHT
	z_index = 5
	_build_collision()
	_build_camera()
	_build_blob_shadow()

func _build_collision() -> void:
	_interaction_area = Area2D.new()
	var shape_node := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 20.0
	shape_node.shape = shape
	_interaction_area.add_child(shape_node)
	_interaction_area.body_entered.connect(_on_area_entered)
	_interaction_area.body_exited.connect(_on_area_exited)
	add_child(_interaction_area)

func _build_camera() -> void:
	_camera = Camera2D.new()
	_camera.name = "Camera"
	_camera.position_smoothing_enabled = true
	_camera.position_smoothing_speed = 5.0
	_camera.drag_horizontal_enabled = true
	_camera.drag_horizontal_offset = 0.0
	_camera.limit_smoothed = true
	add_child(_camera)
	_camera.make_current()

func _build_blob_shadow() -> void:
	_blob_shadow = ShadowSystem.create_blob_shadow(Vector2(14, 4))
	_blob_shadow.position = Vector2(0, HEIGHT)
	add_child(_blob_shadow)

func _process(delta: float) -> void:
	if frozen or GameState.player_frozen:
		is_walking = false
		velocity = 0.0
		queue_redraw()
		return

	var dir := 0.0
	if Input.is_action_pressed("move_right"):
		dir = 1.0
		facing_right = true
	elif Input.is_action_pressed("move_left"):
		dir = -1.0
		facing_right = false

	velocity = dir * WALK_SPEED
	position.x += velocity * delta

	# Clamp within room bounds
	var env := SceneManager.get_current_env()
	if env and env.has_method("get_bounds"):
		var bounds: Vector2 = env.get_bounds()
		position.x = clampf(position.x, bounds.x, bounds.y)

	is_walking = dir != 0.0
	if is_walking:
		_walk_cycle += delta * 8.0
		_step_timer -= delta
		if _step_timer <= 0.0:
			_step_timer = 0.28
			AudioManager.play_footstep()
	else:
		_walk_cycle = 0.0

	# Interact
	if Input.is_action_just_pressed("interact"):
		if DialogueManager.is_active():
			DialogueManager.advance()
		elif _nearby_interactable != null:
			interaction_requested.emit(_nearby_interactable)
			if _nearby_interactable.has_method("interact"):
				_nearby_interactable.interact()
		AudioManager.play_interact()

	# Inventory
	if Input.is_action_just_pressed("open_inventory"):
		var hud := get_tree().root.get_node_or_null("Main/UILayer/HUD")
		if hud and hud.has_method("toggle_inventory"):
			hud.toggle_inventory()

	queue_redraw()

func _draw() -> void:
	var flip := -1.0 if facing_right else 1.0
	var walk_offset := sin(_walk_cycle) * 2.0 if is_walking else 0.0

	# Shadow (lighter version drawn here for accuracy)
	# Colors
	var skin   := Color(0.85, 0.72, 0.60)
	var dark   := Color(0.20, 0.18, 0.22)
	var shirt  := Color(0.30, 0.35, 0.55)
	var pants  := Color(0.18, 0.20, 0.28)
	var shoes  := Color(0.15, 0.14, 0.16)
	var hair   := Color(0.22, 0.18, 0.14)

	# Leg positions (walk cycle)
	var leg_l := sin(_walk_cycle) * 3.0 if is_walking else 0.0
	var leg_r := -leg_l

	# Pixel art Beck — 8px wide, 24px tall, standing
	var ox := 0.0  # horizontal origin
	var oy := 0.0  # top of head

	# Head (4x4)
	draw_rect(Rect2(ox - 2, oy, 4, 4), skin)
	draw_rect(Rect2(ox - 2, oy, 4, 2), hair)

	# Torso (4x8)
	draw_rect(Rect2(ox - 2, oy + 4, 4, 8), shirt)

	# Left arm
	draw_rect(Rect2(ox - 4, oy + 4, 2, 6), shirt)
	# Right arm
	draw_rect(Rect2(ox + 2, oy + 4, 2, 6), shirt)

	# Legs
	draw_rect(Rect2(ox - 2, oy + 12 + leg_l, 2, 8), pants)
	draw_rect(Rect2(ox,     oy + 12 + leg_r, 2, 8), pants)

	# Shoes
	draw_rect(Rect2(ox - 2, oy + 20 + leg_l, 2, 2), shoes)
	draw_rect(Rect2(ox,     oy + 20 + leg_r, 2, 2), shoes)

	# Eyes (1px)
	var eye_x := ox + 1 if facing_right else ox - 2
	draw_rect(Rect2(eye_x, oy + 2, 1, 1), dark)

func _on_area_entered(body: Node) -> void:
	if body.has_method("interact"):
		_nearby_interactable = body

func _on_area_exited(body: Node) -> void:
	if _nearby_interactable == body:
		_nearby_interactable = null

func freeze() -> void:
	frozen = true
	is_walking = false
	velocity = 0.0

func unfreeze() -> void:
	frozen = false

func get_camera() -> Camera2D:
	return _camera

func set_camera_limits(left: float, right: float) -> void:
	if _camera:
		_camera.limit_left = int(left)
		_camera.limit_right = int(right)
