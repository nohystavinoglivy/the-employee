extends Node2D

@export var npc_name: String = "NPC"
@export var dialogue_lines: Array = []
@export var npc_color: Color = Color(0.55, 0.50, 0.45)
@export var walking: bool = false
@export var walk_direction: float = 1.0
@export var walk_speed: float = 40.0
@export var interaction_enabled: bool = true

var _interacted: bool = false
var _walk_cycle: float = 0.0
var _walk_timer: float = 0.0
const HEIGHT := GameData.BECK_HEIGHT

func _ready() -> void:
	z_index = 4
	if walking:
		_walk_timer = randf_range(1.0, 4.0)

func _process(delta: float) -> void:
	if walking and not DialogueManager.is_active():
		_walk_cycle += delta * 7.0
		position.x += walk_direction * walk_speed * delta
		# Despawn if far off screen
		if absf(position.x - get_viewport().get_camera_2d().get_screen_center_position().x) > 800.0:
			queue_free()
	queue_redraw()

func _draw() -> void:
	var dark  := npc_color.darkened(0.5)
	var light := npc_color.lightened(0.3)
	var leg_l := sin(_walk_cycle) * 3.0 if walking else 0.0
	var leg_r := -leg_l

	# Simple NPC — slightly different proportions from Beck
	draw_rect(Rect2(-2, 0, 4, 4), light)                # head
	draw_rect(Rect2(-2, 4, 4, 8), npc_color)            # torso
	draw_rect(Rect2(-4, 4, 2, 5), npc_color)            # left arm
	draw_rect(Rect2( 2, 4, 2, 5), npc_color)            # right arm
	draw_rect(Rect2(-2, 12 + leg_l, 2, 8), dark)        # left leg
	draw_rect(Rect2( 0, 12 + leg_r, 2, 8), dark)        # right leg
	draw_rect(Rect2(-2, 20 + leg_l, 2, 2), dark.darkened(0.3))  # shoe L
	draw_rect(Rect2( 0, 20 + leg_r, 2, 2), dark.darkened(0.3))  # shoe R

func interact() -> void:
	if not interaction_enabled:
		return
	if dialogue_lines.is_empty():
		return
	DialogueManager.start_sequence(dialogue_lines)

func set_dialogue(lines: Array) -> void:
	dialogue_lines = lines
