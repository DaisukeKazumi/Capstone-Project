extends Node2D

var npc_name: String = "Little Girl"

# --- Dialogue Pools ---
var wish_dialogues: Array[String] = [
	"I wish I could do the things boys do...",
	"They say girls shouldn’t climb trees, but I want to!",
	"Sometimes I feel like I’m not allowed to be adventurous."
]

var prove_dialogues: Array[String] = [
	"Guess what? I climbed the tallest tree in the village!",
	"I can run faster than most boys!",
	"I sneak into the fields and play just like them."
]

var befriend_dialogue: String = "You’re different… I think we’re friends now. Here, take this charm — it will protect you."

var final_dialogue: String = "We’re friends forever, right? That charm will keep you safe."

# --- State ---
var interaction_count: int = 0
var reward_given: bool = false

# --- Interaction ---
func interact():
	interaction_count += 1
	
	if interaction_count <= 5:

		var line = wish_dialogues[randi() % wish_dialogues.size()]
		_show_dialogue(line)
	elif interaction_count <= 10:

		var line = prove_dialogues[randi() % prove_dialogues.size()]
		_show_dialogue(line)
	elif interaction_count == 11 and not reward_given:

		_show_dialogue(befriend_dialogue)
		_give_reward()
		reward_given = true
	else:
		_show_dialogue(final_dialogue)

# --- Helpers ---
func _show_dialogue(line: String):
	print(npc_name, " says: ", line)


func _give_reward():
	print(npc_name, " gives you a Defense Charm!")
	Globals.add_item("Defense Charm")
	Globals.apply_defense_buff(0.5)  
