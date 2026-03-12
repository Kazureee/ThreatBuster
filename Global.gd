extends Node

signal stats_updated
signal coins_updated

# Persistent data
var wave_count = 0
var max_waves = 20
var base_wave_time = 25
var wave_time_multiplier = 1.1

# Player basic stats
var player_health = 50
var player_max_health = 50
var player_def = 0
var player_coins = 10000
var player_base_speed = 150   # Store the player's base speed
var player_speed = 150
var player_base_damage = 5
var weapon_range = 300.0

#Player Special stats
var player_Malwarebytes = 0
var player_ESET = 0
var player_Cloudflare = 0
var player_OWASP = 0


# Function to reset the game state
func reset_game():
	wave_count = 0
	player_health = 20
	player_max_health = 20
	player_coins = 0 
	player_speed = 150  # Reset to base speed
	player_base_damage = 5
	weapon_range = 300.0
	
	player_Malwarebytes = 0
	player_ESET = 0
	player_Cloudflare = 0
	player_OWASP = 0
	# Reset any debuff flags or effects
	reset_debuff()

# Function to reset debuff effects
func reset_debuff():
	player_speed = player_base_speed  # Ensure player speed is reset
	print("Debuff reset: Player speed restored to base speed.")
	
func add_coins(amount):
	player_coins += amount
	emit_signal("coins_updated", player_coins)  # 🔹 Pass the updated coins value
	print("Coins added! Current balance:", player_coins)

func remove_coins(amount):
	if player_coins >= amount:
		player_coins -= amount
		emit_signal("coins_updated", player_coins)  # 🔹 Pass the updated coins value
		print("Coins deducted! Current balance:", player_coins)

func update_stat():
	emit_signal("stats_updated")  # Notify all connected nodes to update
