extends CharacterBody2D

@onready var player = get_node("/root/Game/Player")
signal enemy_died

var health = 1000
var speed = 50
var is_vulnerable_to_Malwarebytes = false
var is_vulnerable_to_ESET = false
var is_vulnerable_to_OWASP = true
var is_vulnerable_to_Cloudflare = true

func _physics_process(_delta):
	if player:
		var direction = global_position.direction_to(player.global_position)

# Flip sprite when moving left
		if velocity.x < 0:
			$Sprite2D.flip_h = true  # Face left
		elif velocity.x > 0:
			$Sprite2D.flip_h = false  # Face right (default)
		velocity = direction * speed
		move_and_slide()

func take_damage(damage: int, attack_name: String):
	var base_damage = Global.player_base_damage
	var owasp_damage = 0
	var cloudflare_damage = 0

	# Check which attack is hitting and apply additional damage if the character is vulnerable
	if attack_name.find("OWASP") != -1 and is_vulnerable_to_OWASP:
		owasp_damage = Global.player_OWASP * 1.5
	if attack_name.find("Cloudflare") != -1 and is_vulnerable_to_Cloudflare:
		cloudflare_damage = Global.player_Cloudflare

	var total_damage = base_damage + owasp_damage + cloudflare_damage
	health -= total_damage

	# Show separate floating texts for each damage type
	if base_damage > 0:
		show_floating_text(str(base_damage), Color(0, 0, 0))  
	if owasp_damage > 0:
		show_floating_text(str(int(owasp_damage)), Color(0, 1, 0))  
	if cloudflare_damage > 0:
		show_floating_text(str(int(cloudflare_damage)), Color(1, 1, 1))  

	print("Taking Damage | Base:", base_damage, "| OWASP:", owasp_damage, "| Cloudflare:", cloudflare_damage, "| Health:", health)

	if health <= 0:
		drop_coin()
		call_deferred("queue_free")



func show_floating_text(damage_text: String, color: Color):
	# Create a new Label node dynamically
	var floating_label = Label.new()
	floating_label.text = damage_text
	floating_label.add_theme_color_override("font_color", color)
	floating_label.add_theme_font_size_override("font_size", 20)

	# Attach to enemy initially
	add_child(floating_label)
	
	# Introduce a slight horizontal offset for better separation
	var x_offset = randf_range(-10, 10)  # Random shift left or right
	var y_offset = randf_range(-5, 5)  # Small vertical variation
	
	# Detach from enemy and position globally
	floating_label.reparent(get_tree().current_scene)
	floating_label.global_position = global_position + Vector2(x_offset, -10 + y_offset)

	# Animate floating text upwards and fade out
	var tween = get_tree().create_tween()
	tween.tween_property(floating_label, "position", floating_label.position + Vector2(0, -40), 1.5)
	tween.tween_property(floating_label, "modulate:a", 0, 1.5)

	await tween.finished
	floating_label.queue_free()  # Remove after animation
	
func drop_coin():
	var coin_scene = preload("res://coin.tscn")  # Load the coin scene
	var coin_instance = coin_scene.instantiate()  # Create an instance of the coin
	
	coin_instance.global_position = global_position  # Set coin position to mob's last location
	
	get_parent().call_deferred("add_child", coin_instance)  # Safely add the coin to the scene
