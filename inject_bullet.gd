extends Area2D

@export var base_speed: float = 200  # Base speed of the bullet
@export var base_curve_strength: float = 2.5  # Base curve strength
@export var damage: int = 5  # Damage value for the bullet

var travelled_distance: float = 0
var angular_speed: float  # Dynamic rotation speed
var direction: Vector2  # Movement direction
var curve_increase: float  # Curve gets stronger over time
var speed: float  # Bullet speed changes over time
var oscillation_amplitude: float  # Bullet waves up/down

func _ready():
	# Randomize initial settings for unpredictable behavior
	curve_increase = randf_range(0.02, 0.05)  # Curve increases over time
	speed = base_speed * randf_range(0.8, 1.5)  # Speed variance
	angular_speed = randf_range(0.1, 0.3) * (-1 if randi() % 2 == 0 else 1)  # Random rotation direction
	oscillation_amplitude = randf_range(5, 15)  # Oscillation strength
	
func _physics_process(delta: float) -> void:
	const MAX_RANGE = 1200  # Increase bullet range to be dangerous for longer
	
	# Move the bullet forward
	global_position += direction * speed * delta
	
	# Gradually increase the curve effect and make it more erratic
	angular_speed += curve_increase * delta
	direction = direction.rotated(angular_speed * base_curve_strength * delta)
	
	# Add wave-like oscillation effect
	global_position.y += sin(travelled_distance * 0.02) * oscillation_amplitude * delta
	
	# Occasionally switch rotation direction to make dodging impossible
	if travelled_distance > 400 and travelled_distance < 600 and randi() % 10 == 0:
		angular_speed *= -1  
	
	# Check if the bullet exceeded its range
	travelled_distance += speed * delta
	if travelled_distance > MAX_RANGE:
		queue_free()  # Remove the bullet

# Called when the bullet collides with a body
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if randi() % 2 == 0:
			if body.has_method("take_damage"):
				body.take_damage(damage, "InjectionBullet")  
		else:
			if body.has_method("remove_coins"):
				body.remove_coins(5)  
		
		queue_free()  # Remove the bullet after hitting the player
