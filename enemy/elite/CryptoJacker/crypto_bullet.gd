extends Area2D

var travelled_distance = 0
var damage = 2  # Damage value for the bullet

# Called every frame to move the bullet
func _physics_process(delta: float) -> void:
	const SPEED = 200
	const RANGE = 1000
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()  # Remove the bullet if it travels beyond its range

# Called when the bullet collides with a body
func _on_body_entered(body: Node2D) -> void:
	# Check if the body is the player (using the "player" group)
	if body.is_in_group("player"):
		# Randomly decide whether to damage the player or reduce coins
		var random_choice = randi() % 2  # Generates either 0 or 1
		
		if random_choice == 0:
			# Damage the player
			if body.has_method("take_damage"):
				body.take_damage(damage, "CryptoBullet")  # Pass damage and source
		else:
			# Reduce player's coins by 1
			if body.has_method("remove_coins"):
				body.remove_coins(1)
		
		queue_free()  # Remove the bullet after hitting the player
