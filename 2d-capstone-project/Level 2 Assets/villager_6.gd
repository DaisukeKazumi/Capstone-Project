extends "res://Code/VillagerBase.gd"

var wish_dialogues = [
	"I wish I could do the things boys do...",
	"They say girls shouldn’t climb trees, but I want to!",
	"Sometimes I feel like I’m not allowed to be adventurous."
]

var prove_dialogues = [
	"Guess what? I climbed the tallest tree in the village!",
	"I can run faster than most boys!",
	"I sneak into the fields and play just like them."
]

var befriend_dialogue = "You’re different… I think we’re friends now. Here, take this charm — it will protect you."
var final_dialogue = "We’re friends forever, right? That charm will keep you safe."
var reward_given: bool = false

func _handle_dialogue() -> void:
	if interaction_count <= 5:
		_show_dialogue(wish_dialogues[randi() % wish_dialogues.size()])
	elif interaction_count <= 10:
		_show_dialogue(prove_dialogues[randi() % prove_dialogues.size()])
	elif interaction_count == 11 and not reward_given:
		_show_dialogue(befriend_dialogue)
		DialogueBox.show_text(npc_name, ["You received a Defense Charm!"])
		Globals.add_item("Defense Charm")
		Globals.apply_defense_buff(0.5)
		reward_given = true
	else:
		_show_dialogue(final_dialogue)
