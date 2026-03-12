extends CanvasLayer

@onready var health_label = $Control/HBoxContainer/HealthBar/Health
@onready var health_bar = $Control/HBoxContainer/HealthBar
@onready var speed_label = $Control/Speed
@onready var level_label = $Control/Level
@onready var exp_label = $Control/Exp
@onready var coin_label = $Control/CoinLabel  # Path to the CoinLabel
@onready var turret_vbox = $Control/VBoxContainer

# Reference to the toggle button
@onready var toggle_button = $"Toggle Turrets"
# Turret UI elements
@onready var turret_boxes = [
	$Control/VBoxContainer/Turret1,
	$Control/VBoxContainer/Turret2,
	$Control/VBoxContainer/Turret3,
	$Control/VBoxContainer/Turret4
]

# Turret prices
const TURRET_PRICE = 50

# Predefined positions for each turret
var turret_positions = [
	Vector2(750, 215),  # Position for Turret 1
	Vector2(420, 215),  # Position for Turret 2
	Vector2(420, 500),  # Position for Turret 3
	Vector2(750, 500)   # Position for Turret 4
]

func _ready():
	Global.connect("coins_updated", Callable(self, "update_coins"))  # Connect to signal
	update_coins(Global.player_coins)  # Update UI at start
	update_health(Global.player_health, Global.player_max_health)
	update_coins(Global.player_coins)

	# Ensure player connection
	var player = get_node("/root/Game/Player")  # Adjust path based on your scene
	if player:
		print("Player found!")
		if player.connect("coins_collected", Callable(self, "_on_coins_collected")) == OK:
			print("Signal connected successfully!")
		else:
			print("Failed to connect coins_collected signal!")
	else:
		print("Player not found!")

	# Connect turret buy buttons
	for i in range(turret_boxes.size()):
		var button = turret_boxes[i].get_node("Button")
		button.connect("pressed", Callable(self, "_on_turret_bought").bind(i))

func _on_player_health_changed(current_health: int, max_health: int) -> void:
	# Update both the health label and the health bar
	update_health(current_health, max_health)

func update_health(current_health: int, max_health: int):
	# Update the health label
	health_label.text = "Health " + str(current_health) + " / " + str(max_health)
	
	# Update the health bar
	health_bar.max_value = max_health
	health_bar.value = current_health

func _on_player_speed_changed(new_speed: int) -> void:
	speed_label.text = "Speed: " + str(new_speed)

func _on_player_leveled_up(level: int) -> void:
	level_label.text = "Level: " + str(level)

func _on_player_exp(exp: int) -> void:
	exp_label.text = "Exp: " + str(exp)
 
func _on_coins_collected(coins: int) -> void:
	print("Updating coin label with coins: ", coins)
	coin_label.text = "Coins: " + str(coins)

# Function to update the coin label
func update_coins(coins: int):
	print("Updating coin label with coins:", coins)
	coin_label.text = "Coins: " + str(coins)  # Update label text

# Function to handle turret purchases
func _on_turret_bought(turret_index: int):
	if Global.player_coins >= TURRET_PRICE:
		Global.player_coins -= TURRET_PRICE
		update_coins(Global.player_coins)
		print("Bought Turret ", turret_index + 1)
		
		# Spawn the turret in the game
		spawn_turret(turret_index)
		
		# Disable the turret box after purchase
		var button = turret_boxes[turret_index].get_node("Button")
		button.disabled = true  # Disable the button to prevent repurchasing
		button.text = "Purchased"  # Update button text
	else:
		print("Not enough coins to buy Turret ", turret_index + 1)

# Function to spawn a turret in the game
func spawn_turret(turret_index: int):
	var turret_scene
	match turret_index:
		0:
			turret_scene = preload("res://Turret/Malwarebyte/cloudflare_turret.tscn")
		1:
			turret_scene = preload("res://Turret/ESET/eset.tscn")
		2:
			turret_scene = preload("res://Turret/Malwarebyte/malwarebyte_turret.tscn")
		3:
			turret_scene = preload("res://Turret/Malwarebyte/owasp_turret.tscn")
	
	if turret_scene:
		var turret = turret_scene.instantiate()
		var game_node = get_node("/root/Game")
		if game_node:
			game_node.add_child(turret)
			# Set the turret's position based on its index
			turret.global_position = turret_positions[turret_index]
		else:
			print("Error: Could not find /root/Game node!")
	else:
		print("Error: Turret scene not found!")
		


func _on_toggle_turrets_pressed() -> void:
	# Toggle the visibility of the turret VBoxContainer
	turret_vbox.visible = !turret_vbox.visible

	# Update the button text based on the visibility
	if turret_vbox.visible:
		toggle_button.text = "Hide Turrets"
	else:
		toggle_button.text = "Show Turrets"
