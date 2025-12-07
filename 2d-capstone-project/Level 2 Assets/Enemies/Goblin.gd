extends CharacterBody2D

var gravity: float = 600.0
var speed: float = 40.0
var health: int = 20
var damage: int = 5

var wander_timer: float = 0.0
var wander_direction: int = 0
var facing_direction: int = 1

var is_attacking: bool = false
var attack_target: Node = null

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D
@onready var attack_timer: Timer = $AttackTimer

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	attack_timer.wait_time = 5.0
	attack_timer.one_shot = false
	attack_timer.timeout.connect(_on_attack_timeout)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	if is_attacking:
		velocity.x = 0
	elif attack_target:
		if attack_target.global_position.x < global_position.x:
			velocity.x = -speed
			facing_direction = -1
		elif attack_target.global_position.x > global_position.x:
			velocity.x = speed
			facing_direction = 1
	else:
		wander_timer -= delta
		if wander_timer <= 0:
			wander_timer = randf_range(1.5, 3.0)
			var choice = randi() % 4
			if choice == 0:
				wander_direction = 0
			else:
				wander_direction = -1 if (randi() % 2 == 0) else 1
		velocity.x = wander_direction * speed
		if wander_direction != 0:
			facing_direction = wander_direction

	move_and_slide()
	_update_animation()

func _update_animation() -> void:
	if is_attacking:
		if attack_target:
			if attack_target.global_position.x < global_position.x:
				facing_direction = -1
			else:
				facing_direction = 1
		anim.play("Attack")
		anim.flip_h = facing_direction < 0
	elif abs(velocity.x) > 0.1:
		anim.play("Walk")
		anim.flip_h = facing_direction < 0
	else:
		anim.play("Idle")
		anim.flip_h = facing_direction < 0

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Goblin"):
		return
	attack_target = body
	is_attacking = true
	attack_timer.start()
	_perform_attack()

func _on_body_exited(body: Node) -> void:
	if body == attack_target:
		attack_target = null
		is_attacking = false
		attack_timer.stop()

func _on_attack_timeout() -> void:
	_perform_attack()

func _perform_attack() -> void:
	if attack_target and attack_target.has_method("take_damage"):
		is_attacking = true
		velocity.x = 0
		if attack_target.global_position.x < global_position.x:
			facing_direction = -1
		else:
			facing_direction = 1
		anim.play("Attack")
		anim.flip_h = facing_direction < 0
		attack_target.take_damage(damage)
		await get_tree().create_timer(0.8).timeout
		is_attacking = false

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	is_attacking = false
	velocity = Vector2.ZERO
	anim.play("Death")
	queue_free()
