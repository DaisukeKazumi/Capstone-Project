extends "res://Code/VillagerBase.gd"

var normal_dialogues = [
	"Back in my day, bread only cost a copper...",
	"Did you know I once wrestled a goose? It won.",
	"The weather feels different every year, don’t you think?",
	"I’ve seen things you wouldn’t believe… mostly goats.",
	"Don’t trust anyone who doesn’t like soup.",
	"My knees hurt, but my spirit is strong!",
	"Sometimes I forget why I came outside."
]

var silent_dialogue = "..."
var angry_dialogues = [
	"Stop bothering me, youngster!",
	"Go find someone else to annoy!",
	"Do I look like your entertainment?",
	"Enough! Leave me alone!"
]

func _handle_dialogue() -> void:
	if interaction_count <= 7:
		_show_dialogue(normal_dialogues[randi() % normal_dialogues.size()])
	elif interaction_count <= 10:
		_show_dialogue(silent_dialogue)
	elif interaction_count <= 15:
		_show_dialogue(angry_dialogues[randi() % angry_dialogues.size()])
	else:
		_show_dialogue("...ignores you.")
