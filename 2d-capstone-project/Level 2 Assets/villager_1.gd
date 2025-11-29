extends Node2D

var npc_name: String = "Old Man"

# --- Dialogue Pools ---
var normal_dialogues: Array[String] = [
	"Back in my day, bread only cost a copper...",
	"Did you know I once wrestled a goose? It won.",
	"The weather feels different every year, don’t you think?",
	"I’ve seen things you wouldn’t believe… mostly goats.",
	"Don’t trust anyone who doesn’t like soup.",
	"My knees hurt, but my spirit is strong!",
	"Sometimes I forget why I came outside."
]

var silent_dialogue: String = "..."

var angry_dialogues: Array[String] = [
	"Stop bothering me, youngster!",
	"Go find someone else to annoy!",
	"Do I look like your entertainment?",
	"Enough! Leave me alone!"
]

# --- State ---
var interaction_count: int = 0

# --- Interaction ---
func interact():
	interaction_count += 1
	
	if interaction_count <= 7:
		# 1–7: random normal dialogue
		var line = normal_dialogues[randi() % normal_dialogues.size()]
		_show_dialogue(line)
	elif interaction_count <= 10:
		# 8–10: silent response
		_show_dialogue(silent_dialogue)
	elif interaction_count <= 15:
		# 11–15: angry responses
		var line = angry_dialogues[randi() % angry_dialogues.size()]
		_show_dialogue(line)
	else:
		# 16+: ignores player
		print(npc_name, " ignores you.")

# --- Helper ---
func _show_dialogue(line: String):
	print(npc_name, " says: ", line)
	# Replace with your dialogue UI system
