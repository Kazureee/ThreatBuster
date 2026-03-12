extends CharacterBody2D

@onready var player = get_node("/root/Game/Player")
signal enemy_died

var health = 1000
var speed = 100
var is_vulnerable_to_Malwarebytes = false
var is_vulnerable_to_ESET = false
var is_vulnerable_to_OWASP = false
var is_vulnerable_to_Cloudflare = true
var player_original_speed = 0
var speed_reduced = false  # Prevent multiple reductions

func _ready():
	if player:
		player_original_speed = Global.player_speed  # Store original player speed

func _physics_process(_delta):
	if player:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
		
		# Apply slowdown effect once
		if not speed_reduced:
			Global.player_speed *= 0.7  # Reduce speed by 30%
			speed_reduced = true

func take_damage(damage: int, attack_name: String):
	var base_damage = Global.player_base_damage
	var cloudflare_damage = 0

	# Check if the attack is Cloudflare-based and apply extra damage if vulnerable
	if attack_name.find("Cloudflare") != -1 and is_vulnerable_to_Cloudflare:
		cloudflare_damage = Global.player_Cloudflare

	var total_damage = base_damage + cloudflare_damage
	health -= total_damage

	# Show separate floating texts for each damage type
	if base_damage > 0:
		show_floating_text(str(base_damage), Color(0, 0, 0))  # Dark gray for base damage
	if cloudflare_damage > 0:
		show_floating_text(str(int(cloudflare_damage)), Color(1, 1, 1))  # White for Cloudflare damage

	print("Taking Damage | Base:", base_damage, "| Cloudflare:", cloudflare_damage, "| Health:", health)

	if health <= 0:
		drop_coin()
		call_deferred("queue_free")
		Global.player_speed = player_original_speed




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
	var coin_scene = preload("res://coin.tscn")
	var coin_instance = coin_scene.instantiate()
	coin_instance.global_position = global_position
	get_parent().call_deferred("add_child", coin_instance)
