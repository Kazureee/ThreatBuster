extends Area2D

@export var coin_value: int = 1  # Set the coin value for this pickup area

signal coin_collected(new_total)

func _ready():
	# Connect the signal if not already connected
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D):
	# Check if the body belongs to the "player" group
	if body.is_in_group("player"):
		print("Player collected a coin! Value: ", coin_value)
		
		# Increase the player's coins
		Global.player_coins += coin_value
		print("Total coins: ", Global.player_coins)
		
		# Emit the coin_collected signal
		emit_signal("coin_collected", Global.player_coins)

		# Destroy the coin after pickup
		queue_free()
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
