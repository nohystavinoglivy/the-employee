class_name GameData

enum SceneID {
	BLACK_SCREEN,
	FOUNDERS_HALLWAY,
	TITLE_SCREEN,
	PART_TITLE_CARD,
	DAY_TITLE_CARD,
	BECKS_APARTMENT,
	STREET,
	OFFICE_LOBBY,
	OFFICE_FLOOR,
	BREAK_ROOM,
	ELEVATOR,
	RECORDS_AREA,
}

enum DialogueStyle {
	NORMAL,
	INTERNAL,
	YAX,
	WAVE,
	SYSTEM,
}

enum Day {
	NONE = 0,
	ONE = 1,
	TWO = 2,
	THREE = 3,
}

# ── Palette ──────────────────────────────────────────────────────────────────

# Founders' Hallway
const COL_HALL_FAR      := Color(0.04, 0.05, 0.15)
const COL_HALL_BG       := Color(0.06, 0.08, 0.22)
const COL_HALL_WALL     := Color(0.09, 0.12, 0.30)
const COL_HALL_FLOOR    := Color(0.05, 0.07, 0.18)
const COL_HALL_SHADOW   := Color(0.02, 0.03, 0.10)
const COL_HALL_LIGHT    := Color(0.55, 0.65, 1.00)
const COL_GOLD          := Color(0.85, 0.70, 0.20)
const COL_GOLD_DARK     := Color(0.55, 0.42, 0.08)
const COL_GOLD_HILIGHT  := Color(1.00, 0.90, 0.50)

# Beck's Apartment
const COL_APT_WALL      := Color(0.72, 0.62, 0.48)
const COL_APT_WALL_FAR  := Color(0.58, 0.50, 0.38)
const COL_APT_FLOOR     := Color(0.48, 0.38, 0.28)
const COL_APT_SHADOW    := Color(0.28, 0.22, 0.15)
const COL_APT_TRIM      := Color(0.82, 0.74, 0.60)
const COL_APT_CEILING   := Color(0.80, 0.70, 0.56)
const COL_APT_LIGHT     := Color(1.00, 0.92, 0.70)

# Street
const COL_SKY_MORNING   := Color(0.58, 0.72, 0.88)
const COL_SKY_HORIZON   := Color(0.78, 0.86, 0.94)
const COL_BLDG_FAR      := Color(0.35, 0.36, 0.40)
const COL_BLDG_MID      := Color(0.28, 0.29, 0.33)
const COL_SIDEWALK      := Color(0.30, 0.30, 0.32)
const COL_ROAD          := Color(0.20, 0.20, 0.22)
const COL_STREET_SHADOW := Color(0.10, 0.10, 0.12)

# Office Interior
const COL_OFF_FAR       := Color(0.08, 0.10, 0.18)
const COL_OFF_WALL      := Color(0.12, 0.16, 0.26)
const COL_OFF_FLOOR     := Color(0.16, 0.19, 0.28)
const COL_OFF_CEIL      := Color(0.10, 0.13, 0.22)
const COL_OFF_SHADOW    := Color(0.04, 0.05, 0.12)
const COL_OFF_LIGHT     := Color(0.80, 0.88, 1.00)
const COL_OFF_TRIM      := Color(0.85, 0.70, 0.20)
const COL_OFF_GLASS     := Color(0.30, 0.40, 0.55, 0.6)

# Common
const COL_WHITE         := Color(0.95, 0.95, 0.92)
const COL_BLACK         := Color(0.00, 0.00, 0.00)
const COL_DIALOGUE_BG   := Color(0.06, 0.06, 0.10, 0.92)
const COL_DIALOGUE_YAX  := Color(0.03, 0.03, 0.08, 0.95)
const COL_DIALOGUE_INT  := Color(0.08, 0.08, 0.14, 0.88)
const COL_DIALOGUE_BORDER := Color(0.85, 0.70, 0.20)

# ── Game constants ────────────────────────────────────────────────────────────

const VIEWPORT_W  := 640
const VIEWPORT_H  := 360
const FLOOR_Y     := 300
const WALL_TOP_Y  := -800
const BECK_HEIGHT := 32
const WALK_SPEED  := 80.0

# Parallax scroll factors (motion_scale.x per layer)
const PARALLAX_FAR  := 0.08
const PARALLAX_MID  := 0.30
const PARALLAX_NEAR := 0.70
const PARALLAX_FG   := 1.25
