class_name Dialogue

# Dialogue entry format:
# { "speaker": String, "text": String, "style": GameData.DialogueStyle }
# speaker "" = no name shown (Chakekix / unnamed voice)
# style WAVE  = wave animation on text

static func distorted(length: int) -> String:
	var pool := "₪∮⌬⌀⌁⌂⌃⌄⌅⌆⌇⌈⌉⌊⌋⌌⌍⌎⌏⌐⌑⌒⌓⌔⌕⌖⌗⌘⌙⌚⌛⌜⌝⌞⌟⧫⬡⬢⬣⬤⬥⬦⬧"
	var out := ""
	for _i in range(length):
		out += pool[randi() % pool.length()]
	return out

# ── Scene 00 — Cold Open: Founders' Hallway ──────────────────────────────────

const COLD_OPEN_YAX := [
	{"speaker": "", "text": "Hi, Chakekix.", "style": GameData.DialogueStyle.WAVE},
]

# ── Title Screen ─────────────────────────────────────────────────────────────

# (Title screen text handled procedurally in TitleScreen.gd)

# ── Scene 01 — Beck's Morning ────────────────────────────────────────────────

const NIGHTSTAND := [
	{"speaker": "BECK", "text": "The book's still open.", "style": GameData.DialogueStyle.INTERNAL},
	{"speaker": "BECK", "text": "I really should finish it.", "style": GameData.DialogueStyle.INTERNAL},
]

const TABLE := [
	{"speaker": "BECK", "text": "It's a table.", "style": GameData.DialogueStyle.INTERNAL},
	{"speaker": "BECK", "text": "It's not moving.", "style": GameData.DialogueStyle.INTERNAL},
]

const CUP := [
	{"speaker": "BECK", "text": "Still here.", "style": GameData.DialogueStyle.INTERNAL},
]

const CLOTH := [
	{"speaker": "BECK", "text": "Red-and-blue plaid.", "style": GameData.DialogueStyle.INTERNAL},
]

const BOOK := [
	{"speaker": "BECK", "text": "The Path Through Stages: A Guide to Devotion and Rehabilitation through the Yaxnah.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "\"Complete the stages. Honor the Yax. Be rehabilitated.\"", "style": GameData.DialogueStyle.NORMAL},
]

const MORNING_INTERNAL := [
	{"speaker": "BECK", "text": "I need to get to work.", "style": GameData.DialogueStyle.INTERNAL},
	{"speaker": "BECK", "text": "I don't want to be late again.", "style": GameData.DialogueStyle.INTERNAL},
	{"speaker": "BECK", "text": "I should've packed something.", "style": GameData.DialogueStyle.INTERNAL},
	{"speaker": "BECK", "text": "Doesn't matter.", "style": GameData.DialogueStyle.INTERNAL},
	{"speaker": "BECK", "text": "I'll eat at work.", "style": GameData.DialogueStyle.INTERNAL},
]

# ── Scene 03 — First Chakekix Interruption ───────────────────────────────────

const CHAKEKIX_INTERRUPT := [
	{"speaker": "", "text": "'Work?' Yeah, you're not eating at 'work.'", "style": GameData.DialogueStyle.YAX},
	{"speaker": "", "text": "The name alone says itself:", "style": GameData.DialogueStyle.YAX},
	{"speaker": "", "text": "'go hungry.'", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "Um...", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "What?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "You're going to be hungry.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "I guess so...", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "if I don't eat at work.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "'Go hungry.'", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "...", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Okay.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "I really need to sleep more.", "style": GameData.DialogueStyle.INTERNAL},
]

# ── Scene 04 — Player Name Input ─────────────────────────────────────────────

const NAME_INPUT_PRE := [
	{"speaker": "", "text": "Ugh...", "style": GameData.DialogueStyle.YAX},
	{"speaker": "", "text": "how do I even make this thing move?", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "Huh?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "You.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "...", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Huh?", "style": GameData.DialogueStyle.NORMAL},
]

const NAME_INPUT_DISTORTED_1 := "I'm not stuck, am I?"
const NAME_INPUT_DISTORTED_2 := "So I am."

const NAME_INPUT_MID: Array = []  # Built dynamically with distorted text

static func get_name_input_sequence(player_name: String) -> Array:
	return [
		{"speaker": "", "text": "Ugh... how do I even make this thing move?", "style": GameData.DialogueStyle.YAX},
		{"speaker": "BECK", "text": "Huh?", "style": GameData.DialogueStyle.NORMAL},
		{"speaker": "", "text": "You.", "style": GameData.DialogueStyle.YAX},
		{"speaker": "BECK", "text": "...", "style": GameData.DialogueStyle.NORMAL},
		{"speaker": "BECK", "text": "Huh?", "style": GameData.DialogueStyle.NORMAL},
		{"speaker": "", "text": distorted(8) + "... I'm not stuck, am I?", "style": GameData.DialogueStyle.YAX},
		{"speaker": "", "text": "Okay. So I am. " + distorted(6) + "!!!", "style": GameData.DialogueStyle.YAX},
		{"speaker": "", "text": "And in a " + distorted(5) + " named 'BECK!'", "style": GameData.DialogueStyle.YAX},
		{"speaker": "", "text": "This is. Truly. " + distorted(5) + "'s worst torture.", "style": GameData.DialogueStyle.YAX},
		{"speaker": "BECK", "text": "Well... um.", "style": GameData.DialogueStyle.NORMAL},
		{"speaker": "BECK", "text": "I can, maybe, give you a name?", "style": GameData.DialogueStyle.NORMAL},
		{"speaker": "BECK", "text": "Well. What do you want to be called?", "style": GameData.DialogueStyle.NORMAL},
	]

static func get_name_confirm_sequence(player_name: String) -> Array:
	return [
		{"speaker": "", "text": "Yeah. Get that right. " + player_name + ".", "style": GameData.DialogueStyle.YAX},
		{"speaker": "", "text": "Better than Beck.", "style": GameData.DialogueStyle.YAX},
		{"speaker": "BECK", "text": "...", "style": GameData.DialogueStyle.NORMAL},
		{"speaker": "BECK", "text": "Okay. Sure.", "style": GameData.DialogueStyle.NORMAL},
	]

# ── Scene 05 — Leaving Home ──────────────────────────────────────────────────

const DOOR_BLOCKED := [
	{"speaker": "BECK", "text": "I must have forgotten something.", "style": GameData.DialogueStyle.INTERNAL},
]

# ── Scene 06 — Street Commute ────────────────────────────────────────────────

const NPC_MORNING_PASSING := [
	{"speaker": "NPC", "text": "Morning.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Morning.", "style": GameData.DialogueStyle.NORMAL},
]

const NPC_SECOND := [
	{"speaker": "NPC", "text": "You're with [COMPANY], right?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Yeah.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "NPC", "text": "Thought so.", "style": GameData.DialogueStyle.NORMAL},
]

# ── Day 1 — Workstation ──────────────────────────────────────────────────────

const SUPERVISOR_DAY1 := [
	{"speaker": "SUPERVISOR", "text": "First day?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "I guess.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "SUPERVISOR", "text": "Then let's make it easy.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "SUPERVISOR", "text": "Process today's employee forms.", "style": GameData.DialogueStyle.NORMAL},
]

const TASK_COMPLETE_DAY1 := [
	{"speaker": "SYSTEM", "text": "COMPLETE", "style": GameData.DialogueStyle.SYSTEM},
	{"speaker": "SYSTEM", "text": "GOOD WORK.", "style": GameData.DialogueStyle.SYSTEM},
	{"speaker": "SYSTEM", "text": "HAXOLKIN: PASSING STATUS RECORDED", "style": GameData.DialogueStyle.SYSTEM},
]

# ── Day 1 — Break Room ───────────────────────────────────────────────────────

const COWORKER_BREAK_DAY1 := [
	{"speaker": "COWORKER", "text": "Beck.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Yeah?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "COWORKER", "text": "You eat yet?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "No.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "COWORKER", "text": "You should.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "COWORKER", "text": "The company doesn't like people skipping meals.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Since when?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "COWORKER", "text": "Since always.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "COWORKER", "text": "Didn't you know?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Apparently not.", "style": GameData.DialogueStyle.NORMAL},
]

const SAVE_TERMINAL := [
	{"speaker": "SYSTEM", "text": "SAVE CURRENT EMPLOYEE STATE?", "style": GameData.DialogueStyle.SYSTEM},
]

const SAVE_CONFIRMED := [
	{"speaker": "SYSTEM", "text": "EMPLOYEE STATE RECORDED.", "style": GameData.DialogueStyle.SYSTEM},
]

# ── Day 1 — Night ────────────────────────────────────────────────────────────

const NIGHT_DAY1 := [
	{"speaker": "BECK", "text": "That wasn't so bad.", "style": GameData.DialogueStyle.INTERNAL},
	{"speaker": "", "text": "It was boring.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "That's what work is.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "No.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "Um... no?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "That's what boring work is.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "You have a lot to say for something that didn't exist yesterday.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "I think I existed.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "Oh, okay. I guess that's reassuring.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "Wasn't meant to be.", "style": GameData.DialogueStyle.YAX},
]

# ── Day 2 — Morning ──────────────────────────────────────────────────────────

const MORNING_DAY2 := [
	{"speaker": "BECK", "text": "Day two.", "style": GameData.DialogueStyle.INTERNAL},
	{"speaker": "", "text": "Apparently.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "That's usually how numbers work.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "Is that a joke?", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "No.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "It should've been.", "style": GameData.DialogueStyle.YAX},
]

# ── Day 2 — Office ───────────────────────────────────────────────────────────

const SUPERVISOR_DAY2 := [
	{"speaker": "SUPERVISOR", "text": "Morning.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Morning.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "SUPERVISOR", "text": "Today's task is simple.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "SUPERVISOR", "text": "Check the employee inventory records.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Okay.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "SUPERVISOR", "text": "If something doesn't match, don't correct it.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "What?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "SUPERVISOR", "text": "Report it.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "SUPERVISOR", "text": "That's important.", "style": GameData.DialogueStyle.NORMAL},
]

const DISCREPANCY_FOUND := [
	{"speaker": "SYSTEM", "text": "FLAG DISCREPANCY.", "style": GameData.DialogueStyle.SYSTEM},
	{"speaker": "SYSTEM", "text": "DISCREPANCY RECORDED.", "style": GameData.DialogueStyle.SYSTEM},
]

# ── Day 2 — Paperwork ────────────────────────────────────────────────────────

const PAPERWORK_DAY2 := [
	{"speaker": "BECK", "text": "Weird.", "style": GameData.DialogueStyle.INTERNAL},
	{"speaker": "", "text": "What?", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "Nothing.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "That's not nothing.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "It's a symbol.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "Symbols are usually something.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "You don't know what it means.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "Neither do you.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "Exactly.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "Then we're equally useless.", "style": GameData.DialogueStyle.YAX},
]

# ── Day 2 — Coworker East Elevator ───────────────────────────────────────────

const COWORKER_ELEVATOR_DAY2 := [
	{"speaker": "COWORKER", "text": "You use the east elevator?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Sometimes.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "COWORKER", "text": "Don't.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Why?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "COWORKER", "text": "It's slower.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "COWORKER", "text": "Obviously.", "style": GameData.DialogueStyle.NORMAL},
]

# ── Day 2 — Night ────────────────────────────────────────────────────────────

const NIGHT_DAY2 := [
	{"speaker": "BECK", "text": "That symbol again.", "style": GameData.DialogueStyle.INTERNAL},
	{"speaker": "", "text": "What symbol?", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "The one from work.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "I don't see anything.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "You're inside my head.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "That doesn't mean I have eyes.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "Right.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Do you have a name?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "...", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "Hello?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "I don't think so.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "That's weird.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "You're the one who named me.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "I didn't name you.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "You did.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "When?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "This morning.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "I named—", "style": GameData.DialogueStyle.NORMAL},
]

# ── Day 3 — Commute ──────────────────────────────────────────────────────────

const NPC_DAY3_COMMUTE := [
	{"speaker": "NPC", "text": "You're Beck, right?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Yeah.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "NPC", "text": "Thought so.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Have we met?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "NPC", "text": "No.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "NPC", "text": "Not properly.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Oh.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "NPC", "text": "See you around.", "style": GameData.DialogueStyle.NORMAL},
]

# ── Day 3 — Office ───────────────────────────────────────────────────────────

const SUPERVISOR_DAY3 := [
	{"speaker": "SUPERVISOR", "text": "I need these delivered.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Where?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "SUPERVISOR", "text": "Records.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Where's that?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "SUPERVISOR", "text": "You haven't been there?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "No.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "SUPERVISOR", "text": "Elevator. Third floor. Follow the signs.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "SUPERVISOR", "text": "You can find it.", "style": GameData.DialogueStyle.NORMAL},
]

const RECORDS_EMPLOYEE_DAY3 := [
	{"speaker": "RECORDS EMPLOYEE", "text": "These are for processing?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "That's what I was told.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "RECORDS EMPLOYEE", "text": "Then they're for processing.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Okay.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "RECORDS EMPLOYEE", "text": "Unless they're not.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Are they?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "RECORDS EMPLOYEE", "text": "I don't know.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "RECORDS EMPLOYEE", "text": "You're not in Records.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "I know.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "RECORDS EMPLOYEE", "text": "Good.", "style": GameData.DialogueStyle.NORMAL},
]

# ── Day 3 — Founders' Hallway Oddity ────────────────────────────────────────

const HALLWAY_ODDITY_DAY3 := [
	{"speaker": "", "text": "Don't.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "Don't what?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "Look.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "At what?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "Exactly.", "style": GameData.DialogueStyle.YAX},
]

# ── Day 3 — Break Room ───────────────────────────────────────────────────────

const COWORKER_BREAK_DAY3 := [
	{"speaker": "COWORKER", "text": "You ever wonder why everyone eats in here?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "It's a break room.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "COWORKER", "text": "Right.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "So...", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "COWORKER", "text": "Never mind.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "COWORKER", "text": "You should eat.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "You said that yesterday.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "COWORKER", "text": "Did I?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Yeah.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "COWORKER", "text": "Huh.", "style": GameData.DialogueStyle.NORMAL},
]

# ── Day 3 — Final Night ──────────────────────────────────────────────────────

const FINAL_NIGHT := [
	{"speaker": "BECK", "text": "Three days.", "style": GameData.DialogueStyle.INTERNAL},
	{"speaker": "", "text": "Three.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "That's not very long.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "It feels long.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "You don't have anything to compare it to.", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "Neither do you.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "What do you remember?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "BECK", "text": "Anything?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "Red.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "What?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "A star.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "That's it?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "No.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "Then what else?", "style": GameData.DialogueStyle.NORMAL},
	{"speaker": "", "text": "Someone said my name.", "style": GameData.DialogueStyle.YAX},
	{"speaker": "BECK", "text": "What was it?", "style": GameData.DialogueStyle.NORMAL},
]

# ── Portrait inspection ───────────────────────────────────────────────────────

static func get_portrait_inspect(founder_name: String) -> Array:
	return [
		{"speaker": "BECK", "text": "Founder — " + founder_name, "style": GameData.DialogueStyle.INTERNAL},
		{"speaker": "BECK", "text": "COMPANY FOUNDING EXECUTIVE", "style": GameData.DialogueStyle.INTERNAL},
	]

const FOUNDER_NAMES := [
	"Thomas Hargrove", "Eleanor Voss", "Richard Mael", "Constance Lidd",
	"William Farr", "Susan Oake", "Gerald Punt", "Agnes Wolfe",
]
