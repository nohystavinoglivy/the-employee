extends CanvasLayer

# ── Inventory Screen ──────────────────────────────────────────────────────────

var _selected_idx: int = -1
var _visible_flag: bool = false

func _ready() -> void:
	layer = 60
	hide()

func toggle() -> void:
	if _visible_flag:
		close()
	else:
		open()

func open() -> void:
	_visible_flag = true
	show()
	queue_redraw()

func close() -> void:
	_visible_flag = false
	_selected_idx = -1
	hide()

func _draw() -> void:
	var font := ThemeDB.fallback_font
	# Overlay
	draw_rect(Rect2(0, 0, GameData.VIEWPORT_W, GameData.VIEWPORT_H), Color(0, 0, 0, 0.80))
	# Panel
	draw_rect(Rect2(40, 30, 560, 300), Color(0.07, 0.08, 0.14))
	draw_rect(Rect2(40, 30, 560, 2), Color(GameData.COL_OFF_TRIM, 0.7))
	draw_rect(Rect2(40, 328, 560, 2), Color(GameData.COL_OFF_TRIM, 0.7))
	draw_rect(Rect2(40, 30, 2, 300), Color(GameData.COL_OFF_TRIM, 0.7))
	draw_rect(Rect2(598, 30, 2, 300), Color(GameData.COL_OFF_TRIM, 0.7))

	# Header
	var header := "INVENTORY"
	var hs := 10
	var hw := font.get_string_size(header, HORIZONTAL_ALIGNMENT_LEFT, -1, hs).x
	draw_string(font, Vector2(320.0 - hw / 2.0, 50), header,
		HORIZONTAL_ALIGNMENT_LEFT, -1, hs, Color(GameData.COL_OFF_TRIM, 0.9))
	draw_rect(Rect2(40, 56, 560, 1), Color(GameData.COL_OFF_TRIM, 0.3))

	var items: Array = GameState.inventory
	if items.is_empty():
		var empty_txt := "— no items —"
		var ew := font.get_string_size(empty_txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 7).x
		draw_string(font, Vector2(320.0 - ew / 2.0, 180), empty_txt,
			HORIZONTAL_ALIGNMENT_LEFT, -1, 7, Color(0.50, 0.52, 0.58))
	else:
		for i in range(items.size()):
			var item: Dictionary = items[i]
			var iy := 70.0 + float(i) * 48.0
			var selected := i == _selected_idx
			if selected:
				draw_rect(Rect2(44, iy - 2, 552, 44), Color(GameData.COL_OFF_TRIM, 0.10))
			# Item icon (placeholder rect)
			draw_rect(Rect2(52, iy + 2, 36, 36), Color(0.15, 0.18, 0.28))
			draw_rect(Rect2(52, iy + 2, 36, 1), Color(GameData.COL_OFF_TRIM, 0.4))
			draw_rect(Rect2(52, iy + 37, 36, 1), Color(GameData.COL_OFF_TRIM, 0.4))
			draw_rect(Rect2(52, iy + 2, 1, 36), Color(GameData.COL_OFF_TRIM, 0.4))
			draw_rect(Rect2(87, iy + 2, 1, 36), Color(GameData.COL_OFF_TRIM, 0.4))
			# Item name
			var item_name: String = item.get("name", "???")
			draw_string(font, Vector2(98, iy + 16), item_name,
				HORIZONTAL_ALIGNMENT_LEFT, -1, 8,
				Color(GameData.COL_OFF_TRIM, 0.9) if selected else Color(0.88, 0.86, 0.80))
			# Item description
			var desc: String = item.get("desc", "")
			if desc.length() > 0:
				draw_string(font, Vector2(98, iy + 30), desc,
					HORIZONTAL_ALIGNMENT_LEFT, -1, 6, Color(0.60, 0.62, 0.68))

	# Close hint
	draw_string(font, Vector2(500, 322), "[TAB] close",
		HORIZONTAL_ALIGNMENT_LEFT, -1, 6, Color(0.40, 0.42, 0.48))

func _input(event: InputEvent) -> void:
	if not _visible_flag:
		return
	if event.is_action_pressed("open_inventory"):
		close()
	elif event.is_action_pressed("ui_down"):
		_selected_idx = mini(_selected_idx + 1, GameState.inventory.size() - 1)
		queue_redraw()
	elif event.is_action_pressed("ui_up"):
		_selected_idx = maxi(_selected_idx - 1, 0)
		queue_redraw()
