extends Node2D

# ── Main — root script ────────────────────────────────────────────────────────
# Creates world container, UI layer, initialises all systems,
# registers input actions, calls SceneManager.start_game().

var _world: Node2D = null
var _ui_layer: CanvasLayer = null
var _fade: Node = null
var _hud: Node = null
var _dialogue_box: Node = null
var _name_input: Node = null
var _task_iface: Node = null

func _ready() -> void:
	_setup_input_actions()
	_setup_world()
	_setup_ui()
	_connect_signals()
	SceneManager.initialize(_world, _ui_layer, _fade)
	SceneManager.start_game()

# ── World container ───────────────────────────────────────────────────────────

func _setup_world() -> void:
	_world = Node2D.new()
	_world.name = "World"
	add_child(_world)

# ── UI layer ──────────────────────────────────────────────────────────────────

func _setup_ui() -> void:
	_ui_layer = CanvasLayer.new()
	_ui_layer.layer = 10
	_ui_layer.name = "UILayer"
	add_child(_ui_layer)

	# Fade overlay
	var fade_script := load("res://scripts/ui/FadeOverlay.gd")
	_fade = CanvasLayer.new()
	_fade.set_script(fade_script)
	_fade.name = "FadeOverlay"
	add_child(_fade)

	# HUD
	var hud_script := load("res://scripts/ui/HUD.gd")
	_hud = CanvasLayer.new()
	_hud.set_script(hud_script)
	_hud.name = "HUD"
	add_child(_hud)

	# Dialogue box
	var dlg_script := load("res://scripts/ui/DialogueBox.gd")
	_dialogue_box = CanvasLayer.new()
	_dialogue_box.set_script(dlg_script)
	_dialogue_box.name = "DialogueBox"
	add_child(_dialogue_box)

	# Name input
	var name_script := load("res://scripts/ui/NameInputUI.gd")
	_name_input = CanvasLayer.new()
	_name_input.set_script(name_script)
	_name_input.name = "NameInputUI"
	add_child(_name_input)

	# Task interface
	var task_script := load("res://scripts/ui/TaskInterface.gd")
	_task_iface = CanvasLayer.new()
	_task_iface.set_script(task_script)
	_task_iface.name = "TaskInterface"
	add_child(_task_iface)

# ── Signals ───────────────────────────────────────────────────────────────────

func _connect_signals() -> void:
	DialogueManager.initialize(_dialogue_box)
	DialogueManager.dialogue_line_shown.connect(_on_dialogue_line)
	DialogueManager.all_dialogues_done.connect(_on_all_dialogues_done)
	DialogueManager.name_input_requested.connect(_on_name_input_requested)
	if _name_input.has_signal("name_submitted"):
		_name_input.name_submitted.connect(_on_name_submitted)
	if _task_iface.has_signal("task_completed"):
		_task_iface.task_completed.connect(_on_task_completed)
		_task_iface.task_failed.connect(_on_task_failed)

func _on_dialogue_line(line: Dictionary) -> void:
	if _dialogue_box != null:
		_dialogue_box.show_line(line)

func _on_all_dialogues_done() -> void:
	if _dialogue_box != null:
		_dialogue_box.dismiss()

func _on_name_input_requested() -> void:
	if _name_input != null:
		_name_input.activate()

func _on_name_submitted(player_name: String) -> void:
	DialogueManager.start_sequence(Dialogue.get_name_confirm_sequence(player_name))

func _on_task_completed(_day: int) -> void:
	GameState.set_flag("task_done_day" + str(_day), true)
	AudioManager.play_task_complete()

func _on_task_failed(_day: int) -> void:
	AudioManager.play_interact()

# ── Input ─────────────────────────────────────────────────────────────────────

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		DialogueManager.advance()

func _setup_input_actions() -> void:
	# Move left
	if not InputMap.has_action("move_left"):
		InputMap.add_action("move_left")
		var ev := InputEventKey.new()
		ev.keycode = KEY_LEFT
		InputMap.action_add_event("move_left", ev)
		var ev2 := InputEventKey.new()
		ev2.keycode = KEY_A
		InputMap.action_add_event("move_left", ev2)

	# Move right
	if not InputMap.has_action("move_right"):
		InputMap.add_action("move_right")
		var ev := InputEventKey.new()
		ev.keycode = KEY_RIGHT
		InputMap.action_add_event("move_right", ev)
		var ev2 := InputEventKey.new()
		ev2.keycode = KEY_D
		InputMap.action_add_event("move_right", ev2)

	# Interact
	if not InputMap.has_action("interact"):
		InputMap.add_action("interact")
		var ev := InputEventKey.new()
		ev.keycode = KEY_Z
		InputMap.action_add_event("interact", ev)
		var ev2 := InputEventKey.new()
		ev2.keycode = KEY_ENTER
		InputMap.action_add_event("interact", ev2)

	# Open inventory
	if not InputMap.has_action("open_inventory"):
		InputMap.add_action("open_inventory")
		var ev := InputEventKey.new()
		ev.keycode = KEY_TAB
		InputMap.action_add_event("open_inventory", ev)

	# UI up/down (cursor)
	if not InputMap.has_action("ui_up"):
		InputMap.add_action("ui_up")
		var ev := InputEventKey.new()
		ev.keycode = KEY_UP
		InputMap.action_add_event("ui_up", ev)

	if not InputMap.has_action("ui_down"):
		InputMap.add_action("ui_down")
		var ev := InputEventKey.new()
		ev.keycode = KEY_DOWN
		InputMap.action_add_event("ui_down", ev)

	# ui_accept (confirm in menus)
	if not InputMap.has_action("ui_accept"):
		InputMap.add_action("ui_accept")
		var ev := InputEventKey.new()
		ev.keycode = KEY_ENTER
		InputMap.action_add_event("ui_accept", ev)
		var ev2 := InputEventKey.new()
		ev2.keycode = KEY_SPACE
		InputMap.action_add_event("ui_accept", ev2)
