extends CharacterBody2D

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
		var line = explorer_dialogues[randi() % explorer_dialogues.size()]
		_show_dialogue(line)
	elif interaction_count <= 10:
		var line = friendly_dialogues[randi() % friendly_dialogues.size()]
		_show_dialogue(line)
	elif interaction_count == 11 and not reward_given:
		_show_dialogue(reward_dialogue)
		_give_reward()
		reward_given = true
	elif interaction_count > 11:
		_show_dialogue(exclaim_dialogue)

# --- Helpers ---
func _show_dialogue(line: String) -> void:
	DialogueBox.show_text(npc_name, [line])

func _give_reward() -> void:
	DialogueBox.show_text(npc_name, ["You received Salted Food!"])
	Globals.inventory.append("Salted Food")

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		anim.play("Death")
		queue_free()
