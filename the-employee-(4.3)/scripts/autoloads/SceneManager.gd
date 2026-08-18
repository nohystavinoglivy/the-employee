extends Node

signal scene_loaded(scene_id: int)
signal transition_started()
signal transition_finished()

var _world: Node2D = null
var _ui_layer: CanvasLayer = null
var _current_env: Node = null
var _fade: Node = null
var _is_transitioning: bool = false

# ── Environment script map ────────────────────────────────────────────────────
const ENV_SCRIPTS := {
	GameData.SceneID.FOUNDERS_HALLWAY: "res://scripts/environments/FoundersHallway.gd",
	GameData.SceneID.BECKS_APARTMENT:  "res://scripts/environments/BecksApartment.gd",
	GameData.SceneID.STREET:           "res://scripts/environments/Street.gd",
	GameData.SceneID.OFFICE_LOBBY:     "res://scripts/environments/OfficeLobby.gd",
	GameData.SceneID.OFFICE_FLOOR:     "res://scripts/environments/OfficeFloor.gd",
	GameData.SceneID.BREAK_ROOM:       "res://scripts/environments/BreakRoom.gd",
	GameData.SceneID.ELEVATOR:         "res://scripts/environments/ElevatorScene.gd",
	GameData.SceneID.RECORDS_AREA:     "res://scripts/environments/RecordsArea.gd",
}

func initialize(world: Node2D, ui_layer: CanvasLayer, fade_node: Node) -> void:
	_world = world
	_ui_layer = ui_layer
	_fade = fade_node

func start_game() -> void:
	# Begin the complete opening sequence
	_run_opening_sequence()

# ── Opening Sequence ──────────────────────────────────────────────────────────

func _run_opening_sequence() -> void:
	# Screen 00.01 — Black, hold
	_fade.set_black()
	await _wait(1.5)

	# Screen 00.02 — Fade into Founders' Hallway (cold open)
	load_environment(GameData.SceneID.FOUNDERS_HALLWAY)
	await _fade.fade_out(2.0)
	await _wait(0.5)

	# Screen 00.03-00.04 — Player walks right, sees portraits (handled in FoundersHallway)
	# Screen 00.05-00.09 — Portrait becomes central, creature emerges (cutscene in FoundersHallway)
	# Screen 00.09 — YAX speaks "Hi, Chakekix."
	await _wait_for_signal(DialogueManager.all_dialogues_done)

	# Screen 00.10 — Player dismisses dialogue
	await _wait(2.0)

	# Screen 00.11 — Abrupt black + sound
	await _fade.fade_in(0.05)
	AudioManager.play_impact()
	await _wait(0.8)

	# Screen 01.00 — Title screen
	load_environment(GameData.SceneID.TITLE_SCREEN)
	await _fade.fade_out(0.3)
	AudioManager.play_impact()

	await _wait_for_signal(get_tree().create_timer(0.1).timeout)
	# Wait for player to press Enter
	await _wait_for_enter()

	# Screen 01.02 — Part 1 title card
	await _fade.fade_in(0.2)
	_show_day_title("PART 1", "THE EMPLOYEE")
	await _wait(2.5)

	# Transition to Beck's morning
	await _fade.fade_in(0.5)
	load_environment(GameData.SceneID.BECKS_APARTMENT)
	GameState.set_day(1)
	await _fade.fade_out(1.0)

func _wait_for_enter() -> void:
	while not Input.is_action_just_pressed("ui_accept"):
		await get_tree().process_frame

func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func _wait_for_signal(sig) -> void:
	await sig

# ── Day flow ──────────────────────────────────────────────────────────────────

func begin_day(day: int) -> void:
	GameState.set_day(day)
	_show_day_title_card(day)

func _show_day_title(line1: String, line2: String) -> void:
	var card = _ui_layer.get_node_or_null("DayTitleCard")
	if card:
		card.show_card(line1, line2)

func _show_day_title_card(day: int) -> void:
	var subtitles := ["", "EMPLOYEE ORIENTATION", "ROUTINE", "NORMAL OPERATIONS"]
	var sub := subtitles[clampi(day, 0, subtitles.size() - 1)]
	_show_day_title("DAY " + str(day), sub)

# ── Environment loading ───────────────────────────────────────────────────────

func load_environment(scene_id: int) -> void:
	if _current_env:
		_world.remove_child(_current_env)
		_current_env.queue_free()
		_current_env = null

	if scene_id == GameData.SceneID.TITLE_SCREEN:
		_load_title_screen()
		return

	if scene_id not in ENV_SCRIPTS:
		return

	var script_path: String = ENV_SCRIPTS[scene_id]
	var script = load(script_path)
	if not script:
		push_error("SceneManager: failed to load script " + script_path)
		return

	var env = Node2D.new()
	env.set_script(script)
	_world.add_child(env)
	_current_env = env
	GameState.current_scene_id = scene_id
	scene_loaded.emit(scene_id)

func _load_title_screen() -> void:
	var script = load("res://scripts/ui/TitleScreen.gd")
	if not script:
		return
	var ts = Node2D.new()
	ts.set_script(script)
	_ui_layer.add_child(ts)
	_current_env = ts
	GameState.current_scene_id = GameData.SceneID.TITLE_SCREEN
	scene_loaded.emit(GameData.SceneID.TITLE_SCREEN)

func transition_to(scene_id: int, fade_duration: float = 0.5) -> void:
	if _is_transitioning:
		return
	_is_transitioning = true
	transition_started.emit()
	await _fade.fade_in(fade_duration)
	load_environment(scene_id)
	await _fade.fade_out(fade_duration)
	_is_transitioning = false
	transition_finished.emit()

func get_current_env() -> Node:
	return _current_env
