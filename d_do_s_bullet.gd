extends Area2D

var travelled_distance = 0
var damage = 3  # Damage value for the bullet

# Called every frame to move the bullet
func _physics_process(delta: float) -> void:
	const SPEED = 300
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

			# Damage the player
		if body.has_method("take_damage"):
			body.take_damage(damage, "CryptoBullet")  # Pass damage and source
		
		queue_free()  # Remove the bullet after hitting the player
