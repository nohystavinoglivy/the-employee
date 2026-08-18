extends Node

# ── Signals ───────────────────────────────────────────────────────────────────
signal day_changed(new_day: int)
signal player_name_set(name: String)
signal flag_changed(flag: String, value: bool)
signal inventory_changed()

# ── Core state ────────────────────────────────────────────────────────────────
var player_name: String = ""
var current_day: int = 0
var current_scene_id: int = GameData.SceneID.BLACK_SCREEN
var player_frozen: bool = false

# ── Flags ─────────────────────────────────────────────────────────────────────
var flags: Dictionary = {
	"name_given": false,
	"cold_open_done": false,
	"title_seen": false,
	"day1_task_done": false,
	"day1_saved": false,
	"day2_task_done": false,
	"day2_paperwork_found": false,
	"day3_task_done": false,
	"records_visited": false,
	"hallway_oddity_triggered": false,
	"portrait_eye_micro_active": false,
}

# ── Inventory ─────────────────────────────────────────────────────────────────
var inventory: Array[Dictionary] = []

const ITEM_ACCESS_CARD := {
	"id": "access_card",
	"name": "Employee Access Card",
	"description": "Employee access identification.\nKeep on person.",
}

const ITEM_PAPERWORK := {
	"id": "strange_paperwork",
	"name": "Document (Internal)",
	"description": "A standard-looking form.\nThere is a symbol on it.\nYou don't know what it means.",
}

# ── Public API ────────────────────────────────────────────────────────────────

func set_player_name(n: String) -> void:
	player_name = n.strip_edges()
	flags["name_given"] = true
	player_name_set.emit(player_name)

func set_flag(flag: String, value: bool) -> void:
	flags[flag] = value
	flag_changed.emit(flag, value)

func get_flag(flag: String) -> bool:
	return flags.get(flag, false)

func set_day(d: int) -> void:
	current_day = d
	day_changed.emit(d)

func add_item(item: Dictionary) -> void:
	for existing in inventory:
		if existing["id"] == item["id"]:
			return
	inventory.append(item)
	inventory_changed.emit()

func has_item(item_id: String) -> bool:
	for item in inventory:
		if item["id"] == item_id:
			return true
	return false

func remove_item(item_id: String) -> void:
	for i in range(inventory.size()):
		if inventory[i]["id"] == item_id:
			inventory.remove_at(i)
			inventory_changed.emit()
			return

func reset() -> void:
	player_name = ""
	current_day = 0
	player_frozen = false
	inventory.clear()
	for key in flags:
		flags[key] = false
