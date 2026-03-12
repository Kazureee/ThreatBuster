extends CanvasLayer

var items = []  # Holds current shop items
const REROLL_COST = 10  # Adjust cost as needed

# Probability-weighted item database
var item_database = [
	{"name": "Plank", "price": 55, "image": preload("res://Store/1.png"), "rarity": "common", "weight": 50, "stats": {"health": 0.02, "defense": 0.02}},
	{"name": "Wand III", "price": 70, "image": preload("res://Store/2.png"), "rarity": "common", "weight": 50, "stats": {"health": 0.02, "owasp": 2, "malwarebytes": 2}},
	{"name": "Exoskeleton", "price": 34, "image": preload("res://Store/3.png"), "rarity": "common", "weight": 50, "stats": {"speed": 0.04, "health": 0.02}},
	{"name": "Plant", "price": 42, "image": preload("res://Store/4.png"), "rarity": "common", "weight": 50, "stats": {"health": 0.04, "cloudflare": 2, "defense": -0.04}},

	{"name": "Rare Sword", "price": 320, "image": preload("res://Store/5.png"), "rarity": "rare", "weight": 30, "stats": {"health": 0.05, "defense": 0.02, "eset": 2, "speed": -0.04}},
	{"name": "Rare Armor", "price": 280, "image": preload("res://Store/6.png"), "rarity": "rare", "weight": 30, "stats": {"health": 0.05, "defense": 0.02, "malwarebytes": 3, "speed": -0.03}},
	{"name": "Rare Shield", "price": 280, "image": preload("res://Store/7.png"), "rarity": "rare", "weight": 30, "stats": {"health": 0.05, "owasp": 3, "defense": -0.02}},

	{"name": "Epic Staff", "price": 380, "image": preload("res://Store/8.png"), "rarity": "epic", "weight": 15, "stats": {"health": 0.06, "defense": 0.04, "cloudflare": 4, "speed": -0.02}},
	{"name": "Epic Helmet", "price": 380, "image": preload("res://Store/9.png"), "rarity": "epic", "weight": 15, "stats": {"health": 0.06, "speed": 0.04, "malwarebytes": 4, "defense": -0.02}},

	{"name": "Legendary Blade", "price": 500, "image": preload("res://Store/10.png"), "rarity": "legendary", "weight": 5, "stats": {"eset": 5, "malwarebytes": 5, "cloudflare": 5, "owasp": 5}}
]

@onready var item_containers = [
	$PanelContainer/ItemSlot1, 
	$PanelContainer/ItemSlot2, 
	$PanelContainer/ItemSlot3, 
	$PanelContainer/ItemSlot4
]

@onready var reroll_button = $RerollButton
@onready var coin_label = $CoinLabel  # Reference to the CoinLabel

func _ready():
	update_coin_label()  # Initialize the coin label
	generate_shop()
	reroll_button.connect("pressed", _on_reroll_pressed)

# 🔄 Generate 4 random items based on weighted probability
func generate_shop():
	items.clear()
	
	for i in range(4):
		var item_data = get_weighted_random_item()
		items.append(item_data)
		
		var container = item_containers[i]
		var texture_rect = container.get_node("TextureRect")
		texture_rect.texture = item_data["image"]
		texture_rect.custom_minimum_size = Vector2(100, 100)  # Ensure uniform size

		# ✅ Set price text on button
		var button = texture_rect.get_node("Button")
		button.text = str(item_data["price"]) + " Coins"
		button.connect("pressed", _on_item_bought.bind(i))
		button.visible = true

# 🎲 Weighted random selection
func get_weighted_random_item():
	var total_weight = 0
	for item in item_database:
		total_weight += item["weight"]
	
	var rand_weight = randi() % total_weight
	var cumulative_weight = 0

	for item in item_database:
		cumulative_weight += item["weight"]
		if rand_weight < cumulative_weight:
			return item

	return item_database[0]  # Fallback

# 🔄 Reroll shop items (costs coins)
func _on_reroll_pressed():
	if Global.player_coins >= REROLL_COST:
		Global.player_coins -= REROLL_COST
		generate_shop()
		update_coin_label()  # Update the coin label after rerolling
		print("Shop rerolled! Remaining coins:", Global.player_coins)
	else:
		print("Not enough coins to reroll!")

# ✅ Buying an item
func _on_item_bought(index):
	var item = items[index]
	if Global.player_coins >= item["price"]:
		Global.player_coins -= item["price"]
		update_coin_label()  # Update the coin label after buying
		print("Bought:", item["name"])
		
		# Apply stat changes
		apply_stat_changes(item["stats"])
		
		# Hide item image and button
		var container = item_containers[index]
		container.get_node("TextureRect").texture = null
		container.get_node("TextureRect/Button").visible = false
	else:
		print("Not enough coins to buy", item["name"])

# Apply stat changes based on the item's stats
func apply_stat_changes(stats):
	for stat in stats:
		match stat:
			"health":
				Global.player_health += int(Global.player_max_health * stats[stat])
				Global.player_max_health += int(Global.player_max_health * stats[stat])
			"defense":
				Global.player_def += int(Global.player_def * stats[stat])
			"speed":
				Global.player_speed += int(Global.player_base_speed * stats[stat])
			"owasp":
				Global.player_OWASP += int(stats[stat])
			"malwarebytes":
				Global.player_Malwarebytes += int(stats[stat])
			"cloudflare":
				Global.player_Cloudflare += int(stats[stat])
			"eset":
				Global.player_ESET += int(stats[stat])
	
	# Ensure health does not exceed max health
	Global.player_health = min(Global.player_health, Global.player_max_health)
	
	# Update stats in the UI or other systems
	Global.update_stat()
	print("Stats updated:", stats)
# Update the coin label with the current player coins
func update_coin_label():
	coin_label.text = " Coins" + str(Global.player_coins) 

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://game.tscn")
