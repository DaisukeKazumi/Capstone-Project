extends Node

var active_quests: Dictionary = {}

func start_quest(npc_name: String, description: String) -> void:
	active_quests[npc_name] = {"description": description, "completed": false}
	print("Quest started:", description)

func complete_quest(npc_name: String) -> void:
	if active_quests.has(npc_name):
		active_quests[npc_name]["completed"] = true
		print("Quest completed:", active_quests[npc_name]["description"])
