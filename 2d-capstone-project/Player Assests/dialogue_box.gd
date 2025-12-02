extends CanvasLayer

@onready var label: Label = $Panel/Label

# --- Dialogue State ---
var current_lines: Array[String] = []
var current_index: int = 0
var current_npc: String = ""
var is_story_npc: bool = false

func show_text(npc_name: String, lines: Array[String], story_mode: bool = false) -> void:
	# Called by NPC scripts
	current_npc = npc_name
	current_lines = lines
	current_index = 0
	is_story_npc = story_mode
	visible = true
	_update_text()
	# Ensure DialogueBox is drawn on top of UI
	get_tree().root.call_deferred("move_child", self, get_tree().root.get_child_count() - 1)

func _update_text() -> void:
	if current_index < current_lines.size():
		label.text = current_npc + ": " + current_lines[current_index]
	else:
		# End of dialogue
		visible = false

func next_line() -> void:
	if is_story_npc:
		current_index += 1
		_update_text()
	else:
		visible = false

func _process(delta: float) -> void:
	# Allow pressing E to advance dialogue for story NPCs
	if visible and is_story_npc and Input.is_action_just_pressed("interact"):
		next_line()
