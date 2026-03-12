extends Area2D

# Signal to collect the coin
signal coin_collected(value: int)

@export var coin_value: int = 1  # Make the coin value editable in the inspector

func _ready():
	# Connect the signal to call the function when something enters the area
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))

# Function called when something enters the PickupArea
func _on_body_entered(body: Node2D):
	# Check if the body has a pickup method, indicating it's a valid object to collect
	if body.has_method("pickup"):
		body.pickup(coin_value)  # Call the pickup method to collect the object
		emit_signal("coin_collected", coin_value)
		queue_free()  # Remove the coin after it's collected
