extends Node

const SAVE_PATH := "user://employee_state.json"

signal state_saved()
signal state_loaded()

func save_state() -> void:
	var data := {
		"player_name": GameState.player_name,
		"current_day": GameState.current_day,
		"flags": GameState.flags.duplicate(),
		"inventory": GameState.inventory.duplicate(true),
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		state_saved.emit()
		DialogueManager.say_system("EMPLOYEE STATE RECORDED.")
	else:
		push_error("SaveSystem: Could not open save file for writing.")

func load_state() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return false
	var content := file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(content)
	if parsed == null or not parsed is Dictionary:
		return false

	GameState.player_name = parsed.get("player_name", "")
	GameState.current_day = parsed.get("current_day", 0)

	var saved_flags: Dictionary = parsed.get("flags", {})
	for key in saved_flags:
		if key in GameState.flags:
			GameState.flags[key] = saved_flags[key]

	var saved_inv: Array = parsed.get("inventory", [])
	GameState.inventory.clear()
	for item in saved_inv:
		GameState.inventory.append(item)

	state_loaded.emit()
	return true

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
