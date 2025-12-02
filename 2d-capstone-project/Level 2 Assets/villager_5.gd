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
func _show_dialogue(line: String) -> void:
	DialogueBox.show_text(npc_name, [line])

func _give_reward() -> void:
	DialogueBox.show_text(npc_name, ["You received a Stick!"])
	Globals.add_item("Stick")
