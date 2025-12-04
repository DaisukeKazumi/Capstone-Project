extends "res://Code/VillagerBase.gd"

var explorer_dialogues = [
	"I’ve traveled across mountains and seas… the world is vast!",
	"Did you know the desert winds can sing at night?",
	"I once camped under the stars in a land far away.",
	"Exploring teaches you more than any book ever could.",
	"There’s always another horizon waiting to be discovered."
]

var friendly_dialogues = [
	"You’ve been keeping me company, I like that.",
	"Not many care to listen to my stories… thank you.",
	"Sometimes a friend is worth more than treasure.",
	"You remind me of my travel companions — loyal and curious."
]

var reward_dialogue = "Here, take this salted food. It kept me alive on long journeys — it will restore your strength."
var exclaim_dialogue = "What more do you need from a dear friend?!"

var reward_given: bool = false

func _handle_dialogue() -> void:
	if interaction_count <= 5:
		var line = explorer_dialogues[randi() % explorer_dialogues.size()]
		_show_dialogue(line)
	elif interaction_count <= 10:
		var line = friendly_dialogues[randi() % friendly_dialogues.size()]
		_show_dialogue(line)
	elif interaction_count == 11 and not reward_given:
		_show_dialogue(reward_dialogue)
		DialogueBox.show_text(npc_name, ["You received Salted Food!"])
		Globals.inventory.append("Salted Food")
		reward_given = true
	elif interaction_count > 11:
		_show_dialogue(exclaim_dialogue)
