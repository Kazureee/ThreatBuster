extends Area2D

@onready var player = get_node("/root/Game/Player")
@onready var shooting_point = %ShootingPoint

const BULLET = preload("res://enemy/boss/SQL Injection/injection_bullet.tscn")

var alternate_shot = false  # Track every other shot

func _physics_process(_delta):
	var player_in_range = get_overlapping_bodies()
	if player_in_range.size() > 0:
		look_at(player.global_position)  # Enemy faces the player

func shoot():
	var num_bullets = 6  # Number of primary directions
	var angle_step = 360.0 / num_bullets  # 60° spacing

	for i in range(num_bullets):
		var shoot_angle = deg_to_rad(angle_step * i)
		fire_bullet(shoot_angle)

	# Every second shot, add bullets in between the main directions
	if alternate_shot:
		for i in range(num_bullets):
			var extra_shoot_angle = deg_to_rad(angle_step * i + angle_step / 2)  # Offset by 30°
			fire_bullet(extra_shoot_angle)

	# Toggle for next cycle
	alternate_shot = !alternate_shot  

func fire_bullet(angle):
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = shooting_point.global_position
	new_bullet.rotation = angle  # Rotate bullet correctly
	new_bullet.direction = Vector2.RIGHT.rotated(angle)  # Set movement direction
	get_parent().add_child(new_bullet)

func _on_timer_timeout():
	shoot()
