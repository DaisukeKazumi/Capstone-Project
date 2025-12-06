extends Node

var active_quest: Dictionary = {}

func start_quest(npc_name: String, description: String) -> void:
	active_quest = {
		"npc": npc_name,
		"description": description,
		"completed": false
	}
	print("Quest started:", description)

func complete_quest(npc_name: String) -> void:
	if active_quest.has("npc") and active_quest["npc"] == npc_name:
		active_quest["completed"] = true
		print("Quest completed:", active_quest["description"])

func clear_quest() -> void:
	active_quest.clear()
	print("Quest cleared")
