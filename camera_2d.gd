extends Camera2D

# Reference to the player node
var player: Node2D

func _ready() -> void:
	# Assuming the player node is named "Player" and is in the scene
	player = get_node("Player")  # Adjust the path if needed
	
	# Set this Camera2D to be the active camera for the scene
	get_viewport().set_camera(self)

func _process(delta: float) -> void:
	# Follow the player's position
	position = player.position
