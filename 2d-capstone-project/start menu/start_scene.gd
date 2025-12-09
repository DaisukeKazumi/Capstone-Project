extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/ColorRect.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	$CanvasLayer/ColorRect.visible = true
	$CanvasLayer/AnimationPlayer.play("fade_to_black")
	await $CanvasLayer/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file('res://Level 2 Assets/Level2.tscn')


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_about_pressed() -> void:
	get_tree().change_scene_to_file('res://start menu/about_scene.tscn')
