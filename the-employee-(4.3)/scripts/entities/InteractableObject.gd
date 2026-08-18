extends Node2D

@export var object_name: String = "Object"
@export var dialogue_lines: Array = []
@export var one_shot: bool = false
@export var draw_prompt: bool = true

signal interacted(object: Node)

var _used: bool = false
var _player_near: bool = false
var _prompt_alpha: float = 0.0

func _ready() -> void:
	z_index = 3

func _process(delta: float) -> void:
	var target_alpha := 1.0 if _player_near else 0.0
	_prompt_alpha = move_toward(_prompt_alpha, target_alpha, delta * 4.0)
	if _prompt_alpha > 0.01:
		queue_redraw()

func _draw() -> void:
	if not draw_prompt or _prompt_alpha < 0.01:
		return
	var col := Color(GameData.COL_GOLD, _prompt_alpha * 0.9)
	# Small interaction indicator: bracket below object
	draw_rect(Rect2(-8, -2, 2, 4), col)
	draw_rect(Rect2( 6, -2, 2, 4), col)
	draw_rect(Rect2(-8, -2, 16, 2), col)
	draw_rect(Rect2(-8,  2, 16, 2), col)

func interact() -> void:
	if one_shot and _used:
		return
	_used = true
	interacted.emit(self)
	if not dialogue_lines.is_empty():
		DialogueManager.start_sequence(dialogue_lines)
	AudioManager.play_interact()

func set_player_near(near: bool) -> void:
	_player_near = near

func get_object_name() -> String:
	return object_name
