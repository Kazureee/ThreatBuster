extends CanvasLayer


func _on_button_pressed() -> void:
	hide()
	%PauseMenu.visible = true
	%TouchControls.visible = false
	%RWDebuff.visible = false
	%Status.visible = false
	%Stats.visible = true
	get_tree().paused = true
