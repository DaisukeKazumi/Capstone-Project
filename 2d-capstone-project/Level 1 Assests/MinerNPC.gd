extends "res://Code/QuestGiverBase.gd"

# --- Miner-specific dialogue pools ---
var intro_dialogues: Array[String] = [
	"Hey there… who are you? You look lost in these caves.",
	"You don’t remember? Strange… you remind me of someone I once knew.",
	"Your father used to work these mines with me. He was a good man."
]

var quest_dialogue: String = "Listen, I can help you out of here… but first, I need your help."
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
var intro_index: int = 0   # tracks which intro line we’re on

func _handle_dialogue() -> void:
	# 1. Intro dialogues first
	if not quest_given and intro_index < intro_dialogues.size():
		_show_dialogue(intro_dialogues[intro_index])
		intro_index += 1
		return

	# 2. After all intros, give quest dialogue + description
	if not quest_given and intro_index >= intro_dialogues.size():
		var quest_text = "Quest: Collect %d %s" % [quest_amount, quest_item]
		_show_dialogue_array([quest_dialogue, quest_text])

		quest_given = true
		QuestManager.start_quest(npc_name, quest_text)

		# Keep quest text visible for 15 seconds
		var timer := get_tree().create_timer(15.0)
		timer.timeout.connect(func():
			_clear_dialogue()
		)
		return

	# 3. Quest reminders until completion
	if quest_given and not quest_completed:
		if Globals.inventory.count(quest_item) >= quest_amount:
			quest_completed = true
			_show_dialogue(completion_dialogue)
			QuestManager.complete_quest(npc_name)
		else:
			var line = reminder_dialogues[randi() % reminder_dialogues.size()]
			_show_dialogue(line)
		return

	# 4. After completion
	if quest_completed:
		_show_dialogue(completion_dialogue)
	else:
		_show_dialogue(idle_dialogue)


# --- Helper to show multiple lines in sequence ---
func _show_dialogue_array(lines: Array[String]) -> void:
	DialogueBox.show_text(npc_name, lines)
