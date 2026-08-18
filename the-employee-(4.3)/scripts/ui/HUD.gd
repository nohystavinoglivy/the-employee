extends CanvasLayer

# ── Minimal HUD ───────────────────────────────────────────────────────────────
# Day indicator. Task hint. Inventory toggle button.

var _inventory_ui: Node = null
var _show_task_hint: String = ""

func _ready() -> void:
	layer = 40
	var inv_script := load("res://scripts/ui/InventoryUI.gd")
	_inventory_ui = CanvasLayer.new()
	_inventory_ui.set_script(inv_script)
	add_child(_inventory_ui)
	GameState.day_changed.connect(_on_day_changed)

func _draw() -> void:
	var font := ThemeDB.fallback_font
	# Day badge
	var day_str := "DAY " + str(GameState.current_day)
	draw_rect(Rect2(4, 4, 48, 12), Color(0.07, 0.08, 0.14, 0.85))
	draw_rect(Rect2(4, 4, 48, 1), Color(GameData.COL_OFF_TRIM, 0.5))
	draw_string(font, Vector2(8, 14), day_str,
		HORIZONTAL_ALIGNMENT_LEFT, -1, 7, Color(GameData.COL_OFF_TRIM, 0.85))
	# Task hint
	if _show_task_hint.length() > 0:
		var tw := font.get_string_size(_show_task_hint, HORIZONTAL_ALIGNMENT_LEFT, -1, 6).x
		draw_rect(Rect2(GameData.VIEWPORT_W / 2.0 - tw / 2.0 - 4, 4, tw + 8, 10),
			Color(0.05, 0.06, 0.12, 0.7))
		draw_string(font, Vector2(GameData.VIEWPORT_W / 2.0 - tw / 2.0, 12),
			_show_task_hint, HORIZONTAL_ALIGNMENT_LEFT, -1, 6, Color(0.70, 0.72, 0.78))
	# Inventory hint
	draw_string(font, Vector2(GameData.VIEWPORT_W - 50.0, 12), "[TAB] inv",
		HORIZONTAL_ALIGNMENT_LEFT, -1, 5, Color(0.38, 0.40, 0.48))

func _process(_delta: float) -> void:
	queue_redraw()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_inventory"):
		_inventory_ui.toggle()

func set_task_hint(hint: String) -> void:
	_show_task_hint = hint
	queue_redraw()

func _on_day_changed(_day: int) -> void:
	queue_redraw()
