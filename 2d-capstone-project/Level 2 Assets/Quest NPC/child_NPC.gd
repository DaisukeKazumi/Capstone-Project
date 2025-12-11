extends "res://Code/QuestGiverBase.gd"

# --- Child-specific dialogue pools ---
var dialogue_intro: Array[String] = [
	"Today is my birthday...",
	"But the village is under attack!",
	"Please, defend us so the celebration isn’t ruined!"
]

var quest_dialogue: String = "Please, you must defend the village before we can celebrate!"
var dialogue_after_quest: Array[String] = [
	"You saved us!",
	"Thank you for protecting the village."
]

var idle_dialogue: String = "I have nothing more to ask of you."

# --- Quest details ---
var quest_id: String = "defend_village"
var quest_amount: int = 3   

# --- Dialogue progression state ---
var intro_index: int = 0   
var reward_given: bool = false  

func _handle_dialogue() -> void:
	# 1. Intro dialogues first
	if not quest_given and intro_index < dialogue_intro.size():
		_show_dialogue(dialogue_intro[intro_index])
		intro_index += 1
		return

	# 2. After all intros, give quest dialogue + description + confirmation
	if not quest_given and intro_index >= dialogue_intro.size():
		var quest_text = "Quest: Defend the village by defeating 3 goblins"
		var quest_received = "Quest received: Protect village"
		_show_dialogue_array([quest_dialogue, quest_text, quest_received])

		quest_given = true
		QuestManager.start_quest(quest_id, quest_text)

		# Keep quest text visible for 15 seconds
		var timer := get_tree().create_timer(15.0)
		timer.timeout.connect(func():
			_clear_dialogue()
		)
		return

	# 3. Quest reminders until completion
	if quest_given and not quest_completed:
		var goblins_defeated = Globals.goblins_killed 
		if goblins_defeated >= quest_amount:
			quest_completed = true
			_show_dialogue("You did it! The village is safe.")
			QuestManager.complete_quest(quest_id)
		else:
			_show_dialogue("Please defeat " + str(quest_amount - goblins_defeated) + " more goblins before we can celebrate!")
		return

	# 4. After completion
	if quest_completed and not reward_given:
		_give_reward_sequence()
		reward_given = true
	else:
		_show_dialogue(idle_dialogue)


# --- Helpers ---
func _show_dialogue_array(lines: Array[String]) -> void:
	DialogueBox.show_text(npc_name, lines)

func _give_reward_sequence() -> void:
	var reward_lines: Array[String] = [
		"Here, have a piece of cake!",
		"The cake makes you feel stronger... your defense has been boosted!",
		"You’re not just anyone... you’re part of something greater."
	]
	_show_dialogue_array(reward_lines)

	Globals.add_item("Cake")
	Globals.apply_defense_buff(0.8)
