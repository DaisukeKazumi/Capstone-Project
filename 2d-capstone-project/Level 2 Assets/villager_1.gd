extends CharacterBody2D

var npc_name: String = "Old Man"

# --- Dialogue Pools ---
var normal_dialogues: Array[String] = [
	"Back in my day, bread only cost a copper...",
	"Did you know I once wrestled a goose? It won.",
	"The weather feels different every year, don’t you think?",
	"I’ve seen things you wouldn’t believe… mostly goats.",
	"Don’t trust anyone who doesn’t like soup.",
	"My knees hurt, but my spirit is strong!",
	"Sometimes I forget why I came outside."
]

var silent_dialogue: String = "..."
var angry_dialogues: Array[String] = [
	"Stop bothering me, youngster!",
	"Go find someone else to annoy!",
	"Do I look like your entertainment?",
	"Enough! Leave me alone!"
]

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
	print("Body entered villager range:", body.name)
	if body.is_in_group("Player"):
		player_in_range = true
		print("Player detected in range!")

func _on_body_exited(body: Node) -> void:
	print("Body exited villager range:", body.name)
	if body.is_in_group("Player"):
		player_in_range = false
		print("Player left range!")

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
		print("E pressed while in range → interacting")
		interact()
	elif Input.is_action_just_pressed("interact"):
		print("E pressed but player not in range")

func interact() -> void:
	interaction_count += 1
	print("Interacting with villager, count:", interaction_count)

	if interaction_count <= 7:
		_show_dialogue(normal_dialogues[randi() % normal_dialogues.size()])
	elif interaction_count <= 10:
		_show_dialogue(silent_dialogue)
	elif interaction_count <= 15:
		_show_dialogue(angry_dialogues[randi() % angry_dialogues.size()])
	else:
		DialogueBox.show_text(npc_name, ["...ignores you."])

# --- Helpers ---
func _show_dialogue(line: String) -> void:
	print("Showing dialogue:", line)
	DialogueBox.show_text(npc_name, [line])

func take_damage(amount: int) -> void:
	health -= amount
	print("Villager took damage:", amount, " → health:", health)
	if health <= 0:
		anim.play("Death")
		queue_free()

func attack_enemy(enemy: Node) -> void:
	if anim.animation != "Attack":
		anim.play("Attack")
		if enemy.has_method("Hurt"):
			print("Villager attacking enemy:", enemy.name)
			enemy.take_damage(10)
