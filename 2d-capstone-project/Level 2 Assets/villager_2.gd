extends CharacterBody2D

var npc_name: String = "Old Woman"

# --- Dialogue Pools ---
var kind_dialogues: Array[String] = [
	"Ah, dear, you remind me of my own children.",
	"Life is long, but kindness makes it sweet.",
	"Would you like some tea? I always brew too much.",
	"Your eyes carry a story… perhaps one day you’ll tell me.",
	"Patience, child. The world moves faster than it should."
]

var passive_dialogues: Array[String] = [
	"Oh… still here? You must be very lonely.",
	"Do you not have better things to do?",
	"Some people never learn when enough is enough.",
	"It’s sad, really, watching you waste your time.",
	"You remind me of a fly buzzing around endlessly."
]

var irrelevant_dialogue: String = "(She stares at you with indifference, as if you’re no longer worth noticing.)"

# --- State ---
var interaction_count: int = 0
var player_in_range: bool = false
var health: int = 100
var gravity: float = 600.0
var speed: float = 40.0
var wander_timer: float = 0.0
var wander_direction: Vector2 = Vector2.ZERO

# --- References ---
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# --- Setup ---
func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	collision_shape.scale.x = 1
	print("Villager ready: ", npc_name)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = false

# --- Physics ---
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	wander_timer -= delta
	if wander_timer <= 0:
		wander_timer = randf_range(2.0, 4.0)
		wander_direction = Vector2(randf_range(-1, 1), 0).normalized()

	velocity.x = wander_direction.x * speed
	move_and_slide()

	if health <= 0:
		anim.play("Death")
	elif velocity.x != 0:
		anim.play("Walk")
		anim.flip_h = velocity.x < 0
	else:
		anim.play("Idle")

# --- Interaction ---
func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		interact()

func interact() -> void:
	interaction_count += 1
	
	if interaction_count <= 5:
		var line = kind_dialogues[randi() % kind_dialogues.size()]
		_show_dialogue(line)
	elif interaction_count <= 10:
		var line = passive_dialogues[randi() % passive_dialogues.size()]
		_show_dialogue(line)
	else:
		_show_dialogue(irrelevant_dialogue)

# --- Helper ---
func _show_dialogue(line: String) -> void:
	DialogueBox.show_text(npc_name, [line])
