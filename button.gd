extends Button


func _on_pressed() -> void:
	hide()
	get_tree().paused = true
