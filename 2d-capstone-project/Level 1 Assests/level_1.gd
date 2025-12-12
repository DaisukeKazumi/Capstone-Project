extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/AnimationPlayer.play("fade_to__normal")
	await $CanvasLayer/AnimationPlayer.animation_finished


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$CanvasLayer/AnimationPlayer.play("fade_to__normal")
	#await $CanvasLayer/AnimationPlayer.animation_finished
	pass
