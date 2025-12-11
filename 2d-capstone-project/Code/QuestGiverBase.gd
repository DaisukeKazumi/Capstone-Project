extends CharacterBody2D

# --- NPC Info ---
var npc_name: String = "Quest NPC"

# --- Quest State ---
var quest_given: bool = false
var quest_completed: bool = false

# --- Movement State ---
var start_position: Vector2
var wander_range: float = 32.0  
var wander_timer: float = 0.0
var wander_direction: Vector2 = Vector2.ZERO
var gravity: float = 600.0
var speed: float = 30.0
var is_interacting: bool = false
var player_in_range: bool = false

# --- References ---
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var interaction_timer: Timer = $InteractionTimer

# --- Setup ---
func _ready() -> void:
	start_position = global_position
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	interaction_timer.timeout.connect(_on_interaction_timeout)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
		DialogueBox.hide_text()

# --- Physics ---
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
		var offset = global_position.x - start_position.x
		if abs(offset) > wander_range:
			wander_direction = Vector2(sign(start_position.x - global_position.x), 0)
		else:
			wander_direction = Vector2(randf_range(-1, 1), 0).normalized()

	velocity.x = wander_direction.x * speed
	move_and_slide()

	if velocity.x != 0:
		anim.play("Walk")
		anim.flip_h = velocity.x < 0
	else:
		anim.play("Idle")

# --- Interaction ---
func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		interact()

func interact() -> void:
	is_interacting = true
	velocity = Vector2.ZERO
	anim.play("Idle")

	var player = get_tree().get_nodes_in_group("Player")[0]
	anim.flip_h = player.global_position.x < global_position.x

	_handle_dialogue() # Child classes handle this part

	interaction_timer.start()

# --- Helpers ---
func _show_dialogue(line: String, duration: float = 0.0) -> void:
	# Show text in DialogueBox
	DialogueBox.show_text(npc_name, [line])

	# If a duration is provided, clear after that many seconds
	if duration > 0.0:
		var timer := get_tree().create_timer(duration)
		timer.timeout.connect(func():
			_clear_dialogue()
		)

func _clear_dialogue() -> void:
	DialogueBox.hide_text()

func _on_interaction_timeout() -> void:
	is_interacting = false

func mark_quest_completed() -> void:
	quest_completed = true

# --- To be overridden by child classes ---
func _handle_dialogue() -> void:
	pass
