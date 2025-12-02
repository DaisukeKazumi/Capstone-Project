extends Node2D

var npc_name: String = "Villager Woman"

# --- Dialogue Pools ---
var caretaker_dialogues: Array[String] = [
	"I have to prepare meals for my family every day.",
	"Children need guidance, and that’s my duty.",
	"Keeping the home together is harder than it looks.",
	"Sometimes I wish I had more time for myself.",
	"Family comes first, always."
]

var irritated_dialogues: Array[String] = [
	"Please… leave me alone, I have work to do.",
	"Don’t you see I’m busy?",
	"I don’t have time for idle chatter right now."
]

var extortion_dialogue: String = "(She side-eyes you, sighs, and hands you a few coins.) 'Take this and let me be.'"

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
		# 1–5: caretaker lines
		var line = caretaker_dialogues[randi() % caretaker_dialogues.size()]
		_show_dialogue(line)
	elif interaction_count <= 10:
		# 6–10: irritated responses
		var line = irritated_dialogues[randi() % irritated_dialogues.size()]
		_show_dialogue(line)
	elif interaction_count > 10 and not reward_given:
		# After enough nagging: side-eye and give coins
		_show_dialogue(extortion_dialogue)
		_give_reward()
		reward_given = true
	else:
		# After reward: she ignores further interactions
		DialogueBox.show_text(npc_name, ["(She ignores you now.)"])

# --- Helpers ---
func _show_dialogue(line: String) -> void:
	DialogueBox.show_text(npc_name, [line])

func _give_reward() -> void:
	DialogueBox.show_text(npc_name, ["You received 10 gold coins!"])
	Globals.player_gold += 10
