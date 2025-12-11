extends CharacterBody2D

# --- Player Stats ---
var base_health: float = 100.0
var current_health: float = base_health
var attack_power: float = 10.0
var defense: float = 5.0

# Health regeneration
var regen_interval: float = 2.0        
var regen_amount: float = 0.5          
var _regen_accumulator: float = 0.0    

# Double-click detection 
var last_key_time = {}
var double_click_threshold = 0.25  

# Jump tracking
var can_double_jump = false
var is_jumping = false 

# Animation state
var is_busy = false    
var is_running = false  
var can_teleport = true  
var is_attacking: bool = false  

# References
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea   

func _ready() -> void:
	attack_area.monitoring = false
	attack_area.add_to_group("PlayerAttack")
	add_to_group("Player")   
	
func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += Globals.gravity * delta
	else:
		velocity.y = 0
	
	# Movement input
	var move_dir = 0
	if Input.is_action_pressed("move_left"):
		move_dir -= 1
	if Input.is_action_pressed("move_right"):
		move_dir += 1
	
	if move_dir != 0 and not is_busy:
		var direction_action = "move_left" if move_dir < 0 else "move_right"
		if Input.is_action_just_pressed(direction_action) and _is_double_click(direction_action):
			is_running = true

		var speed = Globals.run_speed if is_running else Globals.walk_speed
		velocity.x = move_dir * speed
		anim.flip_h = move_dir < 0

		if is_on_floor() and not is_jumping:
			anim.play("Run" if is_running else "Walk")
		elif not is_on_floor() and is_jumping:
			anim.play("Jump_Left" if move_dir < 0 else "Jump_Right")
	else:
		if is_on_floor() and not is_busy and not is_jumping:
			is_running = false
			anim.play("Idle_lowhealth" if _low_health() else "Idle")
			velocity.x = 0
	
	# Jump 
	if Input.is_action_just_pressed("Jump") and not is_busy:
		if is_on_floor():
			# First jump
			velocity.y = Globals.jump_force
			can_double_jump = true
			is_jumping = true
			anim.play("Jump")
		elif can_double_jump:
			# Second jump (double jump)
			velocity.y = Globals.jump_force
			can_double_jump = false
			is_jumping = true
			anim.play("Jump")
	
	# Attack
	if Input.is_action_just_pressed("Attack") and not is_busy:
		is_busy = true
		is_attacking = true 
		anim.play("Attack")
		anim.frame = 0
		anim.speed_scale = 0.7
		attack_area.monitoring = true

		await anim.animation_finished

		attack_area.monitoring = false
		is_attacking = false   
		is_busy = false
	
	# Teleport
	if Input.is_action_just_pressed("Teleport") and not is_busy:
		_teleport_to_mouse()
	
	move_and_slide()

	if is_on_floor() and is_jumping and not is_busy:
		anim.play("Landing")
		is_jumping = false

	# --- Health regeneration (0.5 health every 2 seconds) ---
	if current_health < base_health:
		_regen_accumulator += delta
		if _regen_accumulator >= regen_interval:
			var ticks := int(_regen_accumulator / regen_interval)
			current_health = min(current_health + regen_amount * ticks, base_health)
			_regen_accumulator -= regen_interval * ticks
	else:
		# reset accumulator when at full health
		_regen_accumulator = 0.0

# --- Helper Functions ---
func _is_double_click(action: String) -> bool:
	var now = Time.get_ticks_msec() / 1000.0
	if last_key_time.has(action) and now - last_key_time[action] <= double_click_threshold:
		last_key_time[action] = now
		return true
	last_key_time[action] = now
	return false

func _low_health() -> bool:
	return current_health < base_health * 0.3

func _teleport_to_mouse() -> void:
	if not can_teleport:
		return   
	can_teleport = false
	is_busy = true

	anim.play("Teleport_Start")
	anim.frame = 0
	anim.speed_scale = 0.7
	await anim.animation_finished

	global_position = get_global_mouse_position()

	anim.play("Teleport_End")
	anim.frame = 0
	anim.speed_scale = 0.7
	await anim.animation_finished

	is_busy = false
	await get_tree().create_timer(Globals.teleport_cooldown).timeout
	can_teleport = true
