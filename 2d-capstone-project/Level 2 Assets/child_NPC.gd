extends Node2D

# --- NPC Properties ---
var npc_name: String = "Child"
var dialogue_intro: Array[String] = [
	"Today is my birthday...",
	"But the village is under attack!",
	"Please, defend us so the celebration isn’t ruined!"
]

var dialogue_after_quest: Array[String] = [
	"You saved us!",
	"Thank you for protecting the village.",
	"Here’s a piece of cake for you.",
	"And... I think I know something about you..."
]

var quest_id: String = "defend_village"
var quest_given: bool = false
var quest_completed: bool = false

# --- References ---
@onready var anim = $AnimatedSprite2D

# --- Interaction ---
func interact():
	if not quest_given:
		_show_dialogue(dialogue_intro)
		_give_quest()
	elif quest_given and not quest_completed:
		print(npc_name, ": Please defend the village before we can celebrate!")
	elif quest_completed:
		_show_dialogue(dialogue_after_quest)
		_give_reward()
		_reveal_player_hint()

# --- Helpers ---
func _show_dialogue(lines: Array[String]):
	for line in lines:
		print(npc_name, " says: ", line)
		# Replace with your dialogue UI system
		await get_tree().create_timer(1.0).timeout

func _give_quest():
	print(npc_name, " gives quest: ", quest_id)
	Globals.active_quests.append(quest_id)
	quest_given = true

func _give_reward():
	print(npc_name, " gives you a piece of cake!") 
	Globals.inventory.append("Cake")  

func _reveal_player_hint():
	print(npc_name, " whispers: 'You’re not just anyone... you’re part of something greater.'")
