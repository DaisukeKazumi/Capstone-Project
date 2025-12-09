extends CharacterBody2D

var npc_name: String = "Cloaked NPC"

# Dialogue sequence
var dialogue_lines: Array[String] = [
	"…You’ve come far, cloaked one. Few dare to seek the shadows of their own past.",
	"I have watched from the edges of this broken world, waiting for the day you would return.",
	"There was once a miner — strong, steadfast, his hands scarred by stone, yet his heart was gentle.",
	"That miner was more than a worker. He was a guardian, chosen to protect the village from the darkness that stirs beneath the earth.",
	"And his child… you… were destined to inherit that mantle. A protector born not of chance, but of purpose.",
	"The people trusted us, sang of our strength. Yet fear is a cruel poison. The elders whispered, doubting what they could not understand.",
	"Then came the day of calamity. Shadows rose, and in the struggle, both father and child were cast away...",
	"The village faltered. Without its guardians, the walls crumbled, the songs faded, and hope became ash.",
	"Years turned to decades. The world grew colder, harsher. The protector became a myth, a story told to children who no longer believed.",
	"But myths have a way of returning. And now… here you stand, cloaked and silent, carrying echoes of what was lost.",
	"You wonder who you are. You wonder why the world feels both familiar and strange.",
	"Look closely — the missing piece of the story is you. The protector who vanished. The child of the miner.",
	"I am your father. I was cast into shadow as you were. I remember the day we disappeared… and the day the village began to die.",
	"You are the story. You are the absence. And now, you are the return.",
	"The world is broken because we were gone. But together, perhaps, it can be mended."
]

var current_line: int = 0
var player_in_range: bool = false
var is_interacting: bool = false

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D
@onready var interaction_timer: Timer = $InteractionTimer

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
		DialogueBox.hide_text()

func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact") and not is_interacting:
		start_dialogue()
	elif is_interacting and Input.is_action_just_pressed("interact"):
		next_line()

func start_dialogue() -> void:
	is_interacting = true
	current_line = 0
	show_line()

func next_line() -> void:
	current_line += 1
	if current_line < dialogue_lines.size():
		show_line()
	else:
		end_dialogue()

func show_line() -> void:
	var line = dialogue_lines[current_line]
	DialogueBox.show_text(npc_name, [line])
	anim.play("Idle")
	var player = get_tree().get_nodes_in_group("Player")[0]
	anim.flip_h = player.global_position.x < global_position.x

func end_dialogue() -> void:
	is_interacting = false
	DialogueBox.hide_text()
	interaction_timer.start()
	# Here you can trigger the quest item reveal (half picture)
	emit_signal("quest_revealed")  # optional custom signal
