extends Node2D

var npc_name: String = "Middle-Aged Man"

# --- Dialogue Pools ---
var explorer_dialogues: Array[String] = [
	"I’ve traveled across mountains and seas… the world is vast!",
	"Did you know the desert winds can sing at night?",
	"I once camped under the stars in a land far away.",
	"Exploring teaches you more than any book ever could.",
	"There’s always another horizon waiting to be discovered."
]

var friendly_dialogues: Array[String] = [
	"You’ve been keeping me company, I like that.",
	"Not many care to listen to my stories… thank you.",
	"Sometimes a friend is worth more than treasure.",
	"You remind me of my travel companions — loyal and curious."
]

var reward_dialogue: String = "Here, take this salted food. It kept me alive on long journeys — it will restore your strength."
var exclaim_dialogue: String = "What more do you need from a dear friend?!"

# --- State ---
var interaction_count: int = 0
var reward_given: bool = false
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
	interaction_count += 1
	
	if interaction_count <= 5:
		# 1–5: explorer stories
		var line = explorer_dialogues[randi() % explorer_dialogues.size()]
		_show_dialogue(line)
	elif interaction_count <= 10:
		# 6–10: friendly lines
		var line = friendly_dialogues[randi() % friendly_dialogues.size()]
		_show_dialogue(line)
	elif interaction_count == 11 and not reward_given:
		# 11th interaction: reward player with salted food
		_show_dialogue(reward_dialogue)
		_give_reward()
		reward_given = true
	elif interaction_count > 11:
		# After reward: exclaim
		_show_dialogue(exclaim_dialogue)

# --- Helpers ---
func _show_dialogue(line: String) -> void:
	DialogueBox.show_text(npc_name, [line])

func _give_reward() -> void:
	DialogueBox.show_text(npc_name, ["You received Salted Food!"])
	Globals.inventory.append("Salted Food")
