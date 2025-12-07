extends "res://Code/VillagerBase.gd"

var rash_dialogues = [
	"I just stole an apple from the market!",
	"Bet you can’t catch me when I run!",
	"I skipped chores today to play in the fields.",
	"Sometimes I sneak into places I shouldn’t… it’s fun!",
	"I threw rocks at the river just to see them splash."
]

var friendly_dialogues = [
	"You’re still here? Maybe you’re trying to be my friend.",
	"Not many stick around… I think I like you.",
	"Friends make the world less boring.",
	"Hey, maybe we can play together sometime."
]

var reward_dialogue = "Here, take this stick. It’s nothing special… but it’s my favorite one."
var final_dialogue = "What more do you want from me? You already have my stick!"
var reward_given: bool = false

func _handle_dialogue() -> void:
	if interaction_count <= 5:
		_show_dialogue(rash_dialogues[randi() % rash_dialogues.size()])
	elif interaction_count <= 10:
		_show_dialogue(friendly_dialogues[randi() % friendly_dialogues.size()])
	elif interaction_count == 11 and not reward_given:
		_show_dialogue(reward_dialogue)
		DialogueBox.show_text(npc_name, ["You received a Stick!"])
		Globals.add_item("Stick")
		reward_given = true
	else:
		_show_dialogue(final_dialogue)
