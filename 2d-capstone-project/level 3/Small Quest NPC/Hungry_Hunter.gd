extends CharacterBody2D

var npc_name: String = "Hungry Hunter"
var rabbits_required: int = 5
var quest_given: bool = false
var quest_completed: bool = false
var player_in_range: bool = false
var is_interacting: bool = false

var can_advance_dialogue := false

var dialogue_lines: Array = []
var current_line: int = 0

var gravity: float = Globals.gravity 

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D

signal quest_rewarded   

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	move_and_slide()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
		DialogueBox.hide_text()
		is_interacting = false
		current_line = 0

func _process(delta: float) -> void:
	#if player_in_range and Input.is_action_just_pressed("interact"):
	#	if not is_interacting:
	#		start_dialogue()
	#	else:
	#		next_line()
	if not player_in_range:
		return

	if Input.is_action_just_pressed("interact"):
		if not is_interacting:
			start_dialogue()
		elif can_advance_dialogue:
			next_line()

func start_dialogue() -> void:
	is_interacting = true
	can_advance_dialogue = false   # 👈 lock advancing
	anim.play("Idle")

	var player = get_tree().get_nodes_in_group("Player")[0]
	anim.flip_h = player.global_position.x < global_position.x

	var rabbits_caught = Globals.rabbits_killed   # use global counter directly

	if not quest_given:
		dialogue_lines = [
			"It's been a harsh season… food is scarce.",
			"I need your help. Please catch 5 rabbits so I can survive the winter.",
			"Bring them to me, and I will reward you."
		]
		quest_given = true

	elif quest_given and not quest_completed:
		if rabbits_caught < rabbits_required:
			dialogue_lines = [
				"You have caught " + str(rabbits_caught) + " rabbits so far.",
				"I still need " + str(rabbits_required - rabbits_caught) + " more."
			]
		elif rabbits_caught >= rabbits_required:
			quest_completed = true
			await get_tree().process_frame
			dialogue_lines = [
				"You’ve done it… these rabbits will keep me alive this winter.",
				"In return, I give you this picture I found.",
				"Strange, isn’t it? The figure wears a cloak… much like yours.",
				"But it is larger, older… perhaps a shadow of who you truly are."
			]
			Globals.add_item("Half Picture")
			#emit_signal("quest_rewarded")
			#await get_tree().process_frame
			#await get_tree().create_timer(2.0).timeout
			$"../Sprite2D".visible = true
			#await get_tree().create_timer(8.0).timeout
			#$"../Sprite2D".visible = false
	else:
		dialogue_lines = [
			"Thank you again. This picture… it feels important."
		]

	current_line = 0
	show_line()
	
	# 👇 allow advancing NEXT frame
	await get_tree().process_frame
	can_advance_dialogue = true

func next_line() -> void:
	current_line += 1
	if current_line < dialogue_lines.size():
		show_line()
	else:
		end_dialogue()

func show_line() -> void:
	DialogueBox.show_text(npc_name, [dialogue_lines[current_line]])

func end_dialogue() -> void:
	is_interacting = false
	current_line = 0
	DialogueBox.hide_text()
