extends CanvasLayer

# Reference to the PauseMenu node


# Function to resume the game and hide the pause menu
func resume():
	hide()
	get_tree().paused = false
	%TouchControls.visible = true
	%Pause.visible = true
	%Status.visible = true
	%Stats.visible = false
	# Check if the Ransomware node exists before showing RWDebuff
	var ransomware = get_node_or_null("/root/Game/Ransomware")
	if ransomware:
		%RWDebuff.visible = true
	else:
		%RWDebuff.visible = false  # Hide if Ransomware is gone
	
# Called when the resume button is pressed
func _on_resume_pressed() -> void:
	resume()
	
# Called when the restart button is pressed
func _on_restart_pressed() -> void:
	Global.reset_game()
	resume()  # Ensure the game is resumed before restarting
	get_tree().reload_current_scene()  # Reload the current scene

# Called when the quit button is pressed
func _on_quit_pressed() -> void:
	resume() 
	Global.reset_game()
	get_tree().change_scene_to_file("res://menu.tscn")  # Go back to the main menu


func _on_book_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/book/book.tscn")
