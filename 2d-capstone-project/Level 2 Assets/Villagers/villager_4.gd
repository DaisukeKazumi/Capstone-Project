extends "res://Code/VillagerBase.gd"

var caretaker_dialogues = [
	"I have to prepare meals for my family every day.",
	"Children need guidance, and that’s my duty.",
	"Keeping the home together is harder than it looks.",
	"Sometimes I wish I had more time for myself.",
	"Family comes first, always."
]

var irritated_dialogues = [
	"Please… leave me alone, I have work to do.",
	"Don’t you see I’m busy?",
	"I don’t have time for idle chatter right now."
]

var extortion_dialogue = "(She side-eyes you, sighs, and hands you a few coins.) 'Take this and let me be.'"
var reward_given: bool = false

func _handle_dialogue() -> void:
	if interaction_count <= 5:
		_show_dialogue(caretaker_dialogues[randi() % caretaker_dialogues.size()])
	elif interaction_count <= 10:
		_show_dialogue(irritated_dialogues[randi() % irritated_dialogues.size()])
	elif interaction_count > 10 and not reward_given:
		_show_dialogue(extortion_dialogue)

		DialogueBox.show_text("System", ["10 gold coins have been received — added to your currency."])

		Globals.player_gold += 10
		reward_given = true
	else:
		_show_dialogue("(She ignores you now.)")
