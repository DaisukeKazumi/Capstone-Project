extends Node2D

var npc_name: String = "Young Man"

# --- Dialogue Pools ---
var rash_dialogues: Array[String] = [
	"I just stole an apple from the market!",
	"Bet you can’t catch me when I run!",
	"I skipped chores today to play in the fields.",
	"Sometimes I sneak into places I shouldn’t… it’s fun!",
	"I threw rocks at the river just to see them splash."
]

var friendly_dialogues: Array[String] = [
	"You’re still here? Maybe you’re trying to be my friend.",
	"Not many stick around… I think I like you.",
	"Friends make the world less boring.",
	"Hey, maybe we can play together sometime."
]

var reward_dialogue: String = "Here, take this stick. It’s nothing special… but it’s my favorite one."

var final_dialogue: String = "What more do you want from me? You already have my stick!"

# --- State ---
var interaction_count: int = 0
var reward_given: bool = false

# --- Interaction ---
func interact():
	interaction_count += 1
	
	if interaction_count <= 5:
		var line = rash_dialogues[randi() % rash_dialogues.size()]
		_show_dialogue(line)
	elif interaction_count <= 10:
		var line = friendly_dialogues[randi() % friendly_dialogues.size()]
		_show_dialogue(line)
	elif interaction_count == 11 and not reward_given:
		_show_dialogue(reward_dialogue)
		_give_reward()
		reward_given = true
	else:
		# After reward: exclaim
		_show_dialogue(final_dialogue)

# --- Helpers ---
func _show_dialogue(line: String):
	print(npc_name, " says: ", line)
	# Replace with your dialogue UI system

func _give_reward():
	print(npc_name, " gives you a stick!")
	Globals.add_item("Stick")  
