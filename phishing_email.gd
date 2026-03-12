extends CanvasLayer

# Array of 10 possible picture paths
var pictures = [
	"res://Email/picture1.png",
	"res://Email/picture2.png",
	"res://Email/picture3.png",
	"res://Email/picture4.png",
	"res://Email/picture6.png",
	"res://Email/picture7.png",
	"res://Email/picture8.png",
	"res://Email/picture9.png",
]

# Reference to the TextureRect and Buttons
@onready var picture_texture: TextureRect = $Control/TextureRect
@onready var accept_button: Button = $Control/AcceptButton
@onready var decline_button: Button = $Control/DeclineButton

# Track the currently displayed picture index
var current_picture_index: int = -1

# Custom signal to notify the main game script that the phishing email is dismissed
signal dismissed

func _ready():
	# Call the function to display a random picture when the scene is ready
	show_random_picture()
	
	# Disconnect signals if they are already connected
	if accept_button.is_connected("pressed", Callable(self, "_on_accept_button_pressed")):
		accept_button.disconnect("pressed", Callable(self, "_on_accept_button_pressed"))
	if decline_button.is_connected("pressed", Callable(self, "_on_decline_button_pressed")):
		decline_button.disconnect("pressed", Callable(self, "_on_decline_button_pressed"))
	
	# Connect the buttons to their respective functions
	accept_button.connect("pressed", Callable(self, "_on_accept_button_pressed"))
	decline_button.connect("pressed", Callable(self, "_on_decline_button_pressed"))

func show_random_picture():
	# Randomly select one picture from the array
	current_picture_index = randi() % pictures.size()
	var selected_picture = load(pictures[current_picture_index])
	
	# Update the TextureRect with the selected picture
	picture_texture.texture = selected_picture

func _on_accept_button_pressed():
	print("Player accepted the picture!")
	# Apply effects based on the current picture
	apply_picture_effects(current_picture_index)
	
	# Notify the main game script
	emit_signal("dismissed")
	
	# Hide only the accept and decline buttons
	accept_button.hide()
	decline_button.hide()

func _on_decline_button_pressed():
	print("Player declined the picture!")
	# Do nothing when declined
	emit_signal("dismissed")
	
	# Hide only the accept and decline buttons
	accept_button.hide()
	decline_button.hide()

func apply_picture_effects(picture_index: int):
	match picture_index:
		0:  # Picture 1
			Global.player_Cloudflare += 5
			Global.player_Malwarebytes += 2
		1:  # Picture 2
			Global.player_ESET += 3
			Global.player_Malwarebytes += 4
		2:  # Picture 3
			Global.player_OWASP += 3
			Global.player_Cloudflare += 2
		3:  # Picture 4
			Global.player_base_speed += 6
			Global.player_OWASP += 3
		4:  # Picture 6
			Global.player_Cloudflare -= 2
			Global.player_Malwarebytes -= 1
		5:  # Picture 7
			Global.player_Malwarebytes -= 2
			Global.player_ESET -= 1
		6:  # Picture 8
			Global.player_OWASP -= 2
			Global.player_Cloudflare -= 2
			Global.player_base_speed -= 2
			Global.player_max_health -= 2
			Global.player_def -= 2
		7:  # Picture 9
			Global.player_base_speed -= 6
			Global.player_OWASP -= 4
		_:
			print("Invalid picture index!")
	Global.update_stat()
# phishing_email.tscn
func show_perks():
	get_tree().paused = true
	%Status.visible = false
	%Stats.visible = true
	%Perks.visible = true


func _on_continue_pressed() -> void:
	hide()
	show_perks()
