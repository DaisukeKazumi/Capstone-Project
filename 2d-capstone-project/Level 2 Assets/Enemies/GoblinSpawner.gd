extends Node2D

@export var goblin_scene: PackedScene
@export var spawn_location: Node2D   

@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	# Configure timer
	spawn_timer.wait_time = 45.0
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(_on_spawn_timeout)
	spawn_timer.start()

func _on_spawn_timeout() -> void:
	# Only spawn if player has killed fewer than 3 goblins
	if Globals.goblins_killed < 3:
		_spawn_goblin()

func _spawn_goblin() -> void:
	if goblin_scene == null:
		return

	var goblin = goblin_scene.instantiate()
	
	# Place goblin at spawner position or a child Position2D
	if spawn_location:
		goblin.global_position = spawn_location.global_position
	else:
		goblin.global_position = global_position

	get_tree().current_scene.add_child(goblin)
