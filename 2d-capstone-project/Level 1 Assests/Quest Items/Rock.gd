extends Node2D 

@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var collected: bool = false

func _ready() -> void:
	# Connect pickup detection
	area.body_entered.connect(_on_body_entered)

	# Start pulsing animation
	if anim_player.has_animation("Pulse"):
		anim_player.play("Pulse")

func _on_body_entered(body: Node) -> void:
	if collected:
		return
	if body.is_in_group("Player"):
		collected = true
		_pickup()

func _pickup() -> void:
	# Increment global rock counter
	Globals.register_rock_collected()
	
	Globals.add_item("Cave Rock")
	
	print("Rock collected! Total:", Globals.rocks_collected)

	# Hide or remove the rock
	queue_free()
