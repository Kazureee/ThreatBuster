extends CanvasLayer

@onready var texture_rect = $TextureRect
@onready var timer = $Timer

func show_alert(image: Texture, should_resume: bool = false):
	# Pause the game
	get_tree().paused = true
	
	# Set the image and show the alert
	texture_rect.texture = image
	visible = true
	
	# Start the timer for 5 seconds
	timer.start(5)
	
	# Store whether the game should resume after the alert
	timer.set_meta("should_resume", should_resume)

func _on_timer_timeout():
	# Hide the alert
	visible = false
	
	# Resume the game only if should_resume is true
	if timer.get_meta("should_resume"):
		get_tree().paused = false
