extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player/CharacterBody2D.set_physics_process(false)
	$MinerNpc/CharacterBody2D.set_physics_process(false)
	
	$Player/CharacterBody2D/AnimatedSprite2D.play("Walk")
	$MinerNpc/CharacterBody2D/AnimatedSprite2D.play("Walk")
	
	$AnimationPlayer.play("cut_scene")
	await $AnimationPlayer.animation_finished
	
	$Player/CharacterBody2D.set_physics_process(true)
	$MinerNpc/CharacterBody2D.set_physics_process(true)
	
	SceneTransition.change_scene('res://Level 2 Assets/Level2.tscn')
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
