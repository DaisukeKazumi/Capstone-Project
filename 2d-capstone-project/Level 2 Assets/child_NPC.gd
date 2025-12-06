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
	"Thank you for protecting the village.",
	"Here’s a piece of cake for you.",
	"And... I think I know something about you..."
]

var idle_dialogue: String = "I have nothing more to ask of you."

# --- Quest details ---
var quest_id: String = "defend_village"
var quest_item: String = "Enemy Defeated"
var quest_amount: int = 1

# --- Dialogue progression state ---
var intro_index: int = 0   # tracks which intro line we’re on

func _handle_dialogue() -> void:
	# 1. Intro dialogues first
	if not quest_given and intro_index < dialogue_intro.size():
		_show_dialogue(dialogue_intro[intro_index])
		intro_index += 1
		return

	# 2. After all intros, give quest dialogue + description + confirmation
	if not quest_given and intro_index >= dialogue_intro.size():
		var quest_text = "Quest: Defend the village from attackers"
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
		if Globals.inventory.count(quest_item) >= quest_amount:
			quest_completed = true
			_show_dialogue("You did it! The village is safe.")
			QuestManager.complete_quest(quest_id)
		else:
			_show_dialogue("Please defend the village before we can celebrate!")
		return

	# 4. After completion
	if quest_completed:
		var line = dialogue_after_quest[randi() % dialogue_after_quest.size()]
		_show_dialogue(line)
		_give_reward()
		_reveal_player_hint()
	else:
		_show_dialogue(idle_dialogue)


# --- Helpers ---
func _show_dialogue_array(lines: Array[String]) -> void:
	DialogueBox.show_text(npc_name, lines)

func _give_reward() -> void:
	Globals.add_item("Cake")

func _reveal_player_hint() -> void:
	_show_dialogue("You’re not just anyone... you’re part of something greater.")
