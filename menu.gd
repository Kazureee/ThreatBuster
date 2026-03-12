extends Control


func _on_player_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_book_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/book/book.tscn")
