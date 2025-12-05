extends "res://Code/QuestGiverBase.gd"

# --- Miner-specific dialogue pools ---
var intro_dialogues: Array[String] = [
	"Hey there… who are you? You look lost in these caves.",
	"You don’t remember? Strange… you remind me of someone I once knew.",
	"Your father used to work these mines with me. He was a good man."
]

var quest_dialogue: String = "Listen, I can help you out of here… but first, I need your help. You've received a quest!"

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

func _handle_dialogue() -> void:
	if not quest_given:
		# First encounter: miner introduces himself and gives quest
		var line = intro_dialogues[randi() % intro_dialogues.size()]
		_show_dialogue(line)
		_show_dialogue(quest_dialogue)
		quest_given = true

		QuestManager.start_quest(npc_name, "Collect " + str(quest_amount) + " " + quest_item)

	elif quest_given and not quest_completed:
		# Check if player has collected enough items
		if Globals.inventory.count(quest_item) >= quest_amount:
			quest_completed = true
			_show_dialogue(completion_dialogue)

			QuestManager.complete_quest(npc_name)
		else:
			var line = reminder_dialogues[randi() % reminder_dialogues.size()]
			_show_dialogue(line)

	elif quest_completed:
		_show_dialogue(completion_dialogue)
	else:
		_show_dialogue(idle_dialogue)
