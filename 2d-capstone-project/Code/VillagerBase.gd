extends CharacterBody2D

var npc_name: String = "Villager"
var interaction_count: int = 0
var player_in_range: bool = false
var health: int = 100
var gravity: float = 600.0
var speed: float = 40.0
var wander_timer: float = 0.0
var wander_direction: Vector2 = Vector2.ZERO
var is_interacting: bool = false

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var interaction_timer: Timer = $InteractionTimer

func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	interaction_timer.timeout.connect(_on_interaction_timeout)
	collision_shape.scale.x = 1
	print("Villager ready: ", npc_name)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
		DialogueBox.hide_text()

func _physics_process(delta: float) -> void:
	if is_interacting:
		velocity = Vector2.ZERO
		return

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

func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		interact()

func interact() -> void:
	interaction_count += 1
	is_interacting = true
	velocity = Vector2.ZERO
	anim.play("Idle")

	var player = get_tree().get_nodes_in_group("Player")[0]
	anim.flip_h = player.global_position.x < global_position.x

	_handle_dialogue()   # delegate to child

	interaction_timer.start()

func _show_dialogue(line: String) -> void:
	DialogueBox.show_text(npc_name, [line])

func _on_interaction_timeout() -> void:
	is_interacting = false

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		anim.play("Death")
		queue_free()

# --- To be overridden by child classes ---
func _handle_dialogue() -> void:
	pass
