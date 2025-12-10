extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_area: Area2D = $Area2D   # Area2D with CollisionShape2D for detecting player attack

var is_alive: bool = true
var health: int = 1

var gravity: float = Globals.gravity
var speed: float = 60.0   # horizontal run speed

func _ready() -> void:
	# Start the movement cycle
	start_cycle()
	# ✅ Connect to area_entered (not body_entered)
	death_area.area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	if not is_alive:
		velocity = Vector2.ZERO
	else:
		# Apply gravity
		if not is_on_floor():
			velocity.y += gravity * delta
		else:
			velocity.y = 0
	move_and_slide()

# --- Movement cycle ---
func start_cycle() -> void:
	_run_for(2.0, func():
		_idle_for(5.0, func():
			_run_for(3.0, func():
				_idle_for(2.0, func():
					_idle()
				)
			)
		)
	)

func _run_for(duration: float, next_action: Callable) -> void:
	if not is_alive: return
	anim.play("Running")
	var dir := -1.0 if randf() < 0.5 else 1.0
	velocity.x = dir * speed
	anim.flip_h = velocity.x < 0
	var timer := get_tree().create_timer(duration)
	timer.timeout.connect(func():
		velocity.x = 0
		next_action.call()
	)

func _idle_for(duration: float, next_action: Callable) -> void:
	if not is_alive: return
	anim.play("Idle")
	velocity.x = 0
	var timer := get_tree().create_timer(duration)
	timer.timeout.connect(next_action)

func _idle() -> void:
	if not is_alive: return
	anim.play("Idle")
	velocity.x = 0

# --- Kill handling ---
func _on_area_entered(area: Area2D) -> void:
	if not is_alive: return
	# ✅ Only fires when PlayerAttack hitbox overlaps, which is enabled only during attack animation
	if area.is_in_group("PlayerAttack"):
		take_damage(1)

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	is_alive = false
	velocity = Vector2.ZERO
	anim.play("Death")
	Globals.register_rabbit_kill()
	var timer := get_tree().create_timer(0.6)   # tweak to match Death animation length
	timer.timeout.connect(func():
		queue_free()
	)
