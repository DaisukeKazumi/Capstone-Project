extends Node2D

var npc_name: String = "Old Woman"

# --- Dialogue Pools ---
var kind_dialogues: Array[String] = [
	"Ah, dear, you remind me of my own children.",
	"Life is long, but kindness makes it sweet.",
	"Would you like some tea? I always brew too much.",
	"Your eyes carry a story… perhaps one day you’ll tell me.",
	"Patience, child. The world moves faster than it should."
]

var passive_dialogues: Array[String] = [
	"Oh… still here? You must be very lonely.",
	"Do you not have better things to do?",
	"Some people never learn when enough is enough.",
	"It’s sad, really, watching you waste your time.",
	"You remind me of a fly buzzing around endlessly."
]

var irrelevant_dialogue: String = "(She stares at you with indifference, as if you’re no longer worth noticing.)"

# --- State ---
var interaction_count: int = 0

# --- Interaction ---
func interact():
	interaction_count += 1
	
	if interaction_count <= 5:
		# 1–5: kind/respectful lines
		var line = kind_dialogues[randi() % kind_dialogues.size()]
		_show_dialogue(line)
	elif interaction_count <= 10:
		# 6–10: passive-aggressive comments
		var line = passive_dialogues[randi() % passive_dialogues.size()]
		_show_dialogue(line)
	else:
		# 11+: irrelevant stare
		_show_dialogue(irrelevant_dialogue)

# --- Helper ---
func _show_dialogue(line: String):
	print(npc_name, " says: ", line)
	# Replace with your dialogue UI system
