extends CanvasLayer

# Reference to the ColorRect nodes
@onready var color_rects = [
	$TextureRect,
	$TextureRect2,
	$TextureRect3
]

# Timer to control the stutter effect
@onready var timer = $Timer

# Track whether the Adware enemy exists
var adware_exists = false

func _ready():
	# Hide all ColorRects initially
	for rect in color_rects:
		rect.visible = false
	
	# Set up the timer (but don't start it yet)
	timer.wait_time = 2  # Set the interval to 2 seconds
	timer.connect("timeout", _on_timer_timeout)
	
	# Connect to the Adware enemy's signals
	var adware = get_node_or_null("/root/Game/Adware")
	if adware:
		adware.connect("enemy_spawned", on_adware_spawned)
		adware.connect("enemy_defeated", on_adware_defeated)

# Called when the Adware enemy spawns
func on_adware_spawned():
	adware_exists = true
	timer.start()  # Start the timer

# Called when the Adware enemy is defeated or removed
func on_adware_defeated():
	adware_exists = false
	timer.stop()  # Stop the timer
	
	# Hide all ColorRects
	for rect in color_rects:
		rect.visible = false

# Called every time the timer times out
func _on_timer_timeout():
	if adware_exists:
		# Toggle visibility of all ColorRects
		for rect in color_rects:
			rect.visible = !rect.visible
