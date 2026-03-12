extends CanvasLayer

# Reference to the TextureRect node
@onready var texture_rect = $Control/TextureRect

# Array to hold the larger images
var larger_images = [
	preload("res://Photo/book/Adware.png"),
	preload("res://Photo/book/Crypto Jacker.png"),
	preload("res://Photo/book/Cyberworm.png"),
	preload("res://Photo/book/DDOS.png"),
	preload("res://Photo/book/Ransomware.png"),
	preload("res://Photo/book/Spyware.png"),
	preload("res://Photo/book/SQL Injection.png"),
	preload("res://Photo/book/Virus.png")
]

func _ready():
	# Initially hide the larger image
	

	# Connect each button to the handler with the appropriate index
	$Control/GridContainer/TextureButton1.connect("pressed", Callable(self, "_on_texture_button_pressed").bind(0))
	$Control/GridContainer/TextureButton2.connect("pressed", Callable(self, "_on_texture_button_pressed").bind(1))
	$Control/GridContainer/TextureButton3.connect("pressed", Callable(self, "_on_texture_button_pressed").bind(2))
	$Control/GridContainer/TextureButton4.connect("pressed", Callable(self, "_on_texture_button_pressed").bind(3))
	$Control/GridContainer/TextureButton5.connect("pressed", Callable(self, "_on_texture_button_pressed").bind(4))
	$Control/GridContainer/TextureButton6.connect("pressed", Callable(self, "_on_texture_button_pressed").bind(5))
	$Control/GridContainer/TextureButton7.connect("pressed", Callable(self, "_on_texture_button_pressed").bind(6))
	$Control/GridContainer/TextureButton8.connect("pressed", Callable(self, "_on_texture_button_pressed").bind(7))

func _on_texture_button_pressed(index):
	# Set the texture of the TextureRect to the corresponding larger image
	texture_rect.texture = larger_images[index]
	# Make the TextureRect visible
	texture_rect.visible = true


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
