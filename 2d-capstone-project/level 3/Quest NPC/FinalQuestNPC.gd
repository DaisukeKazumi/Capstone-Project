extends CharacterBody2D

var npc_name: String = "Cloaked NPC"

# Dialogue sequence
var dialogue_lines = [
	"…You’ve come far, cloaked one. Few dare to seek the shadows of their own past.",
	"There was once a child, born to a miner whose hands were rough but whose heart was kind.",
	"The father dug deep into the earth, bringing light and warmth to his family, never asking for more than the joy of seeing his child smile.",
	"That child grew into someone beloved — a protector. The people sang their praises, for they shielded the weak and gave hope to the weary.",
	"Yet not all voices were kind. The elders whispered, their eyes clouded with suspicion. They feared what they could not understand.",
	"Still, the protector endured… until one day, without warning, they vanished. Gone as though swallowed by the earth itself.",
	"Decades passed. The world grew colder. The memory of the protector became a story told around fires, fading into myth.",
	"But myths have a way of returning. And now… here you stand, cloaked and silent, the echo of that protector reborn.",
	"You wonder who you are. You wonder why the world feels both familiar and strange.",
	"I will show you. Look closely at this picture… half of it remains, worn and incomplete.",
	"The missing piece… is you. The protector who vanished. The child of the miner. The one beloved, feared, and lost.",
    "You are the story. You are the absence. And now, you are the return."
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
