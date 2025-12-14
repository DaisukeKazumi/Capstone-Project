extends "res://Code/QuestGiverBase.gd"

func _ready() -> void:
	npc_name = "Child"   # override parent’s default
	super._ready()            

# --- Child-specific dialogue pools ---
var dialogue_intro: Array[String] = [
	"Today is my birthday...",
	"Our village has been destroyed...",
	"We’re trying to cheer everyone up with a party!",
	"But the village is under attack!",
	"Please, defend us so the celebration isn’t ruined!"
]

var quest_dialogue: String = "Please, you must defend the village so we can have the party and lift everyone’s spirits!"

# After quest completion: thanks + cake reward lines together
var dialogue_after_quest: Array[String] = [
	"You saved us!",
	"Thank you for protecting the village.",
	"Now we can finally have our party to cheer everyone up.",
	"Here, have a piece of cake!",
	"The cake makes you feel stronger... your defense has been boosted!",
	"You’re not just anyone... you’re part of something greater."
]

var idle_dialogue: String = "I have nothing more to ask of you."

# --- Quest details ---
var quest_id: String = "defend_village"
var quest_amount: int = 3   

# --- Dialogue progression state ---
var intro_index: int = 0   
var after_index: int = 0   # track progression through dialogue_after_quest

func _handle_dialogue() -> void:
	# 1. Intro dialogues first
	if not quest_given and intro_index < dialogue_intro.size():
		_show_dialogue(dialogue_intro[intro_index])
		intro_index += 1
		return

	# 2. After all intros, give quest dialogue + description + confirmation
	if not quest_given and intro_index >= dialogue_intro.size():
		var quest_text = "Quest: Defend the village by defeating 3 goblins so the party can happen"
		var quest_received = "Quest received: Protect the village and save the party"
		_show_dialogue_array([quest_dialogue, quest_text, quest_received])

		quest_given = true
		QuestManager.start_quest(quest_id, quest_text)

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
			QuestManager.complete_quest(quest_id)
			after_index = 0
			_show_dialogue(dialogue_after_quest[after_index])
		else:
			_show_dialogue("Please defeat " + str(quest_amount - goblins_defeated) + " more goblins before we can have the party!")
		return

	# 4. After completion, step through the full sequence
	if quest_completed:
		if after_index < dialogue_after_quest.size():
			_show_dialogue(dialogue_after_quest[after_index])
			after_index += 1
		else:
			_show_dialogue(idle_dialogue)

# --- Helpers ---
func _show_dialogue_array(lines: Array[String]) -> void:
	for line in lines:
		_show_dialogue(line)
