extends "res://Code/VillagerBase.gd"

var kind_dialogues = [
	"Ah, dear, you remind me of my own children.",
	"Life is long, but kindness makes it sweet.",
	"Would you like some tea? I always brew too much.",
	"Your eyes carry a story… perhaps one day you’ll tell me.",
	"Patience, child. The world moves faster than it should."
]

var passive_dialogues = [
	"Oh… still here? You must be very lonely.",
	"Do you not have better things to do?",
	"Some people never learn when enough is enough.",
	"It’s sad, really, watching you waste your time.",
	"You remind me of a fly buzzing around endlessly."
]

var irrelevant_dialogue = "(She stares at you with indifference, as if you’re no longer worth noticing.)"

func _handle_dialogue() -> void:
	if interaction_count <= 5:
		_show_dialogue(kind_dialogues[randi() % kind_dialogues.size()])
	elif interaction_count <= 10:
		_show_dialogue(passive_dialogues[randi() % passive_dialogues.size()])
	else:
		_show_dialogue(irrelevant_dialogue)
