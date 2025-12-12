extends "res://Code/VillagerBase.gd"

# Villager 2 inherits everything from VillagerBase
# but overrides dialogue handling to remain silent.

func _handle_dialogue() -> void:
	# Do nothing — this villager does not speak
	pass
