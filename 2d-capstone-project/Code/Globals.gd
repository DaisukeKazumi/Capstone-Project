extends Node

# --- Global Physics Values ---
var gravity: float = 1500
var walk_speed: float = 70
var run_speed: float = 200
var jump_force: float = -400  # original was -600

# --- Global Gameplay Values ---
var max_health: int = 100
var teleport_cooldown: float = 10.0

# --- Player State ---
var player_health: int = max_health
var inventory: Array = []
var active_quests: Array = []
var completed_quests: Array = []
var player_gold: int = 0
var defense_multiplier: float = 1.0

# --- Quest Progress ---
var rabbits_killed: int = 0   # counter for Hungry Hunter quest
var rocks_collected: int = 0  # counter for Miner quest

# --- Inventory Management ---
func add_item(item: String) -> void:
	if not inventory.has(item):
		inventory.append(item)
		print("Added", item, "to inventory.")
	else:
		print(item, "is already in inventory.")

func remove_item(item: String) -> void:
	if inventory.has(item):
		inventory.erase(item)
		print("Removed", item, "from inventory.")

# --- Item Consumption ---
func consume_item(item: String) -> void:
	if not inventory.has(item):
		print("You don't have", item, "to consume.")
		return
	
	match item:
		"Cake":
			player_health = min(player_health + 20, max_health)
			print("You eat the cake. Restored 20 health! Current health:", player_health)
		"Salted Food":
			player_health = min(player_health + 25, max_health)
			print("You eat the salted food. Restored 25 health! Current health:", player_health)
		"Stick":
			print("You admire the stick. It’s just a cool stick, nothing more.")
		"Defense Charm":
			print("You hold the charm. Its protective power is already active.")
		_:
			print("You consume", item, "but nothing happens.")
	
	remove_item(item)

# --- Quest Management ---
func add_quest(quest_id: String) -> void:
	if not active_quests.has(quest_id) and not completed_quests.has(quest_id):
		active_quests.append(quest_id)
		print("Quest started:", quest_id)

func complete_quest(quest_id: String) -> void:
	if active_quests.has(quest_id):
		active_quests.erase(quest_id)
		completed_quests.append(quest_id)
		print("Quest completed:", quest_id)

# --- Rabbit Kill Tracking ---
func register_rabbit_kill() -> void:
	rabbits_killed += 1
	print("Rabbit killed. Total:", rabbits_killed)

func reset_rabbit_kills() -> void:
	rabbits_killed = 0
	print("Rabbit kill counter reset.")

func get_rabbit_progress(required: int) -> String:
	return str(rabbits_killed) + "/" + str(required)

# --- Rock Collection Tracking ---
func register_rock_collected() -> void:
	rocks_collected += 1
	print("Rock collected. Total:", rocks_collected)

func reset_rocks_collected() -> void:
	rocks_collected = 0
	print("Rock counter reset.")

func get_rock_progress(required: int) -> String:
	return str(rocks_collected) + "/" + str(required)

# --- Defense Buff ---
func apply_defense_buff(multiplier: float) -> void:
	defense_multiplier = multiplier
	print("Defense buff applied. Damage taken is now multiplied by", defense_multiplier)

# --- Damage Handling ---
func take_damage(amount: int) -> void:
	var adjusted = int(amount * defense_multiplier)
	player_health = max(player_health - adjusted, 0)
	print("Player took", adjusted, "damage. Health:", player_health)
