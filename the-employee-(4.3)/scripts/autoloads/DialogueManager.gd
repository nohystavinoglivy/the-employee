extends Node

signal dialogue_started()
signal dialogue_line_shown(line: Dictionary)
signal dialogue_advanced()
signal all_dialogues_done()
signal name_input_requested()

var _box: Node = null
var _queue: Array = []
var _active: bool = false
var _waiting_input: bool = false
var _player_name_pending: bool = false

func initialize(dialogue_box: Node) -> void:
	_box = dialogue_box

func start_sequence(lines: Array) -> void:
	_queue = lines.duplicate()
	_active = true
	_waiting_input = false
	dialogue_started.emit()
	_show_next()

func _show_next() -> void:
	if _queue.is_empty():
		_end_sequence()
		return

	var line: Dictionary = _queue.pop_front()
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var style: int = line.get("style", GameData.DialogueStyle.NORMAL)

	var line_dict := {"speaker": speaker, "text": text, "style": style}
	if _box:
		_box.show_line(line_dict)

	_waiting_input = true
	dialogue_line_shown.emit(line_dict)

func advance() -> void:
	if not _active:
		return
	if not _waiting_input:
		if _box and _box.has_method("skip_typewriter"):
			_box.skip_typewriter()
		return
	_waiting_input = false
	dialogue_advanced.emit()
	_show_next()

func _end_sequence() -> void:
	_active = false
	_waiting_input = false
	if _box and _box.has_method("dismiss"):
		_box.dismiss()
	all_dialogues_done.emit()

func is_active() -> bool:
	return _active

func request_name_input() -> void:
	_player_name_pending = true
	name_input_requested.emit()

func on_typewriter_done() -> void:
	# Called by DialogueBox when typewriter finishes
	_waiting_input = true

# ── Quick single-line helper ──────────────────────────────────────────────────

func say(speaker: String, text: String, style: int = GameData.DialogueStyle.NORMAL) -> void:
	start_sequence([{"speaker": speaker, "text": text, "style": style}])

func say_internal(text: String) -> void:
	say("BECK", text, GameData.DialogueStyle.INTERNAL)

func say_yax(text: String) -> void:
	say("", text, GameData.DialogueStyle.YAX)

func say_system(text: String) -> void:
	say("SYSTEM", text, GameData.DialogueStyle.SYSTEM)
