extends Area2D

var damage = 5 # Damage dealt to the player per tick
var damage_rate = 3.0  # Time in seconds between each damage tick
var player_in_area = null  # Stores the player node when inside
@onready var damage_timer = Timer.new()  # Create a Timer instance

func _ready():
	# Connect signals
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

	# Setup the damage timer
	damage_timer.wait_time = damage_rate
	damage_timer.autostart = false
	damage_timer.one_shot = false
	damage_timer.connect("timeout", Callable(self, "_apply_damage"))
	add_child(damage_timer)  # Add the Timer node to the scene

func _on_body_entered(body: Node2D):
	# Check if the body is the player
	if body.name == "Player":
		player_in_area = body  # Store reference to the player
		_apply_damage()  # Apply immediate damage
		damage_timer.start()  # Start the cooldown timer

func _on_body_exited(body: Node2D):
	# Check if the body is the player
	if body.name == "Player":
		player_in_area = null  # Remove reference when the player leaves
		damage_timer.stop()  # Stop the damage timer

func _apply_damage():
	# Apply damage if the player is in the area
	if player_in_area:
		player_in_area.take_damage(damage, "CyberWorm Contact")
