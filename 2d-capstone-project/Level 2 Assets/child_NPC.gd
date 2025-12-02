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
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var player_in_range: bool = false

# --- Setup ---
func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = false

# --- Interaction ---
func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		interact()

func interact() -> void:
	if not quest_given:
		_show_dialogue(dialogue_intro)
		_give_quest()
	elif quest_given and not quest_completed:
		DialogueBox.show_text(npc_name, ["Please defend the village before we can celebrate!"])
	elif quest_completed:
		_show_dialogue(dialogue_after_quest)
		_give_reward()
		_reveal_player_hint()

# --- Helpers ---
func _show_dialogue(lines: Array[String]) -> void:
	# Show dialogue in DialogueBox singleton
	DialogueBox.show_text(npc_name, lines)

func _give_quest() -> void:
	Globals.add_quest(quest_id)
	quest_given = true

func _give_reward() -> void:
	Globals.add_item("Cake")

func _reveal_player_hint() -> void:
	DialogueBox.show_text(npc_name, ["You’re not just anyone... you’re part of something greater."])
