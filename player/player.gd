extends CharacterBody2D

signal health_depleted
signal health_changed(current_health, max_health)
signal speed_changed(new_speed)
signal coins_collected(coins)

@onready var right_sprite = $Right
@onready var left_sprite = $Left
@onready var hurtbox = $HurtBox

func _ready():
	# Add the player to the "player" group
	add_to_group("player")

	# Initialize player stats from Global
	emit_signal("health_changed", Global.player_health, Global.player_max_health)
	emit_signal("speed_changed", Global.player_speed)

func _physics_process(delta):
	# Update UI signals
	emit_signal("health_changed", Global.player_health, Global.player_max_health)
	emit_signal("speed_changed", Global.player_speed)
	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * Global.player_speed
	move_and_slide()

	# Update sprite visibility based on movement direction
	_update_sprite_visibility(direction)

var last_direction = Vector2.RIGHT

func _update_sprite_visibility(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		last_direction = direction

	if last_direction.x < 0:
		left_sprite.visible = true
		right_sprite.visible = false
	elif last_direction.x > 0:
		left_sprite.visible = false
		right_sprite.visible = true

func collect_coin(value: int):
	# Add the coin value to the player's total coins
	Global.player_coins += value
	print("Collected coin! Total coins: ", Global.player_coins)
	
	# Emit the coins_collected signal
	emit_signal("coins_collected", Global.player_coins)

# Define the pickup function to accept an integer (coin value)
func pickup(coin_value: int):
	# Call collect_coin and pass the value directly
	collect_coin(coin_value)

# Function to handle damage
func take_damage(damage: int, source: String):
	# Calculate damage reduction based on player_def (1 def = 1% reduction)
	var defense_multiplier = max(0.1, 1 - min(Global.player_def * 0.02, 0.9))
	var reduced_damage = max(1, int(damage * defense_multiplier))  # Ensure at least 1 damage

	# Apply reduced damage
	Global.player_health -= reduced_damage
	Global.player_health = max(Global.player_health, 0)

	# Emit health update signal
	emit_signal("health_changed", Global.player_health, Global.player_max_health)

	# Debugging logs
	print("Player took ", reduced_damage, " damage from ", source, " (original: ", damage, ", defense: ", Global.player_def, "% reduction)")
	print("Damage called from: ", get_stack())

	if Global.player_health <= 0:
		emit_signal("health_depleted")

		
func remove_coins(amount: int):
	Global.remove_coins(amount)
