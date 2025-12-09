extends "res://Code/QuestGiverBase.gd"

# --- Miner-specific dialogue pools ---
var intro_dialogues: Array[String] = [
	"Hey there… who are you? You look lost in these caves.",
	"You don’t remember? Strange… you remind me of someone I once knew.",
	"Your father used to work these mines with me. He was a good man."
]

# Expanded quest explanation (step through these one by one)
var quest_dialogues: Array[String] = [
	"Listen, I can help you out of here… but first, I need your help.",
	"These tunnels are unstable, and I need sturdy rocks to shore up the passage.",
	"Bring me 5 Cave Rocks so I can make the path safe enough for us to leave."
]

var reminder_dialogues: Array[String] = [
	"Did you collect those rocks yet?",
	"Still waiting… the caves won’t explore themselves.",
	"Remember, I need those materials before we can leave."
]

var completion_dialogue: String = "Well done! You’ve proven yourself. Let’s get you out of here."
var idle_dialogue: String = "I have nothing more for you now."

# --- Quest details ---
var quest_item: String = "Cave Rock"
var quest_amount: int = 5

# --- Dialogue progression state ---
var intro_index: int = 0  
var quest_index: int = 0   # tracks which quest explanation line we’re on

signal lead_player_out   # FOR TRANSITION ONLY

func _handle_dialogue() -> void:
	# 1. Intro dialogues first
	if not quest_given and intro_index < intro_dialogues.size():
		_show_dialogue(intro_dialogues[intro_index])
		intro_index += 1
		return

	# 2. Step through quest explanation dialogues
	if not quest_given and intro_index >= intro_dialogues.size() and quest_index < quest_dialogues.size():
		_show_dialogue(quest_dialogues[quest_index])
		quest_index += 1
		return

	# 3. After all quest explanation lines, give quest text and mark quest as given
	if not quest_given and quest_index >= quest_dialogues.size():
		var quest_text: String = "Quest: Collect %d %s" % [quest_amount, quest_item]
		_show_dialogue(quest_text)

		quest_given = true
		QuestManager.start_quest(npc_name, quest_text)

		# ✅ Clear dialogue after 10 seconds so player goes to do quest
		var timer := get_tree().create_timer(10.0)
		timer.timeout.connect(func():
			_clear_dialogue()
		)
		return

	# 4. Quest reminders until completion
	if quest_given and not quest_completed:
		if Globals.rocks_collected >= quest_amount:  
			quest_completed = true
			_show_dialogue(completion_dialogue)
			QuestManager.complete_quest(npc_name)

			emit_signal("lead_player_out")   # plug-in for transition
		else:
			var line = reminder_dialogues[randi() % reminder_dialogues.size()]
			_show_dialogue(line)
		return

	# 5. After completion (player comes back later)
	if quest_completed:
		_show_dialogue(completion_dialogue)
	else:
		_show_dialogue(idle_dialogue)


# --- Helper to show multiple lines in sequence ---
func _show_dialogue_array(lines: Array[String]) -> void:
	DialogueBox.show_text(npc_name, lines)
