extends Node2D


func _ready() -> void:
	SceneTransition.get_node("ColorRect").visible = false

func _on_play_pressed() -> void:
	SceneTransition.get_node("ColorRect").visible = true
	SceneTransition.change_scene('res://Level 1 Assests/Level1.tscn')


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_about_pressed() -> void:
	get_tree().change_scene_to_file('res://start menu/about_scene.tscn')
