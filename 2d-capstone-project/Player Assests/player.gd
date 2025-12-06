extends CharacterBody2D

# --- Player Stats ---
var base_health: float = 100.0
var current_health: float = base_health
var attack_power: float = 10.0
var defense: float = 5.0

# Double-click detection
var last_key_time = {}
var double_click_threshold = 0.25  

# Jump tracking
var can_double_jump = false
var is_jumping = false   # tracks jump state

# Animation state
var is_busy = false    
var is_running = false  
var can_teleport = true  

# References
@onready var anim = $AnimatedSprite2D
# @onready var audio = $AudioStreamPlayer

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += Globals.gravity * delta
	else:
		velocity.y = 0  # reset when grounded
	
	# Movement input
	var move_dir = 0
	if Input.is_action_pressed("move_left"):
		move_dir -= 1
	if Input.is_action_pressed("move_right"):
		move_dir += 1
	
	if move_dir != 0 and not is_busy:
		var direction_action = "move_left" if move_dir < 0 else "move_right"

		# Detect double‑tap to enable running
		if Input.is_action_just_pressed(direction_action) and _is_double_click(direction_action):
			is_running = true

		var speed = Globals.run_speed if is_running else Globals.walk_speed
		velocity.x = move_dir * speed
		anim.flip_h = move_dir < 0

		if is_on_floor() and not is_jumping:
			anim.play("Run" if is_running else "Walk")
		elif not is_on_floor() and is_jumping:
			if move_dir < 0:
				anim.play("Jump_Left")
			elif move_dir > 0:
				anim.play("Jump_Right")
	else:
		if is_on_floor() and not is_busy and not is_jumping:
			is_running = false
			if _low_health():
				anim.play("Idle_lowhealth")
			else:
				anim.play("Idle")
			velocity.x = 0
	
	# Jump
	if Input.is_action_just_pressed("Jump") and not is_busy:
		if is_on_floor():
			velocity.y = Globals.jump_force
			can_double_jump = true
			is_jumping = true
			anim.play("Jump")
		elif can_double_jump and _is_double_click("Jump"):
			velocity.y = Globals.jump_force
			can_double_jump = false
			is_jumping = true
			anim.play("Jump")
	
	# Attack
	if Input.is_action_just_pressed("Attack") and not is_busy:
		is_busy = true
		anim.play("Attack")
		anim.frame = 0
		anim.speed_scale = 0.7
		await anim.animation_finished
		is_busy = false
	
	# Teleport
	if Input.is_action_just_pressed("Teleport") and not is_busy:
		_teleport_to_mouse()
	
	# Apply movement
	move_and_slide()

	# Landing animation
	if is_on_floor() and is_jumping and not is_busy:
		anim.play("Landing")
		is_jumping = false


# --- Reward Consumption ---
func consume_reward(item_name: String) -> void:
	match item_name:
		"Cake":
			base_health *= 1.5
			current_health = base_health
			DialogueBox.show_text("System", ["Cake has been consumed — Your health increased by 1.5x!"])

		"Defense Charm":
			defense *= 1.5
			DialogueBox.show_text("System", ["Defense Charm has been consumed — Your defense increased by 50%!"])

		"Salted Food":
			attack_power *= 1.2
			DialogueBox.show_text("System", ["Salted Food has been consumed — Your attack power increased by 20%!"])

		_:
			DialogueBox.show_text("System", ["Unknown reward consumed."])


# --- Helper Functions ---
func _is_double_click(action: String) -> bool:
	var now = Time.get_ticks_msec() / 1000.0
	if last_key_time.has(action) and now - last_key_time[action] <= double_click_threshold:
		last_key_time[action] = now
		return true
	last_key_time[action] = now
	return false

func _apply_jump_force():
	velocity.y = Globals.jump_force

func _teleport_to_mouse():
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

func _low_health() -> bool:
	return current_health < base_health * 0.3


# --- Visual Feedback ---
func _show_feedback(message: String) -> void:
	# Simple example: print to console
	print(message)

	# Example: show floating text above player
	var label = Label.new()
	label.text = message
	label.add_theme_color_override("font_color", Color(1, 1, 0)) # yellow
	get_parent().add_child(label)
	label.global_position = global_position + Vector2(0, -32)

	# Animate fade-out
	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_callback(Callable(label, "queue_free"))
