extends Area2D

@onready var player = get_node("/root/Game/Player")
@onready var shooting_point = %ShootingPoint

const BULLET = preload("res://enemy/boss/DDoS/d_do_s_bullet.tscn")

func _physics_process(_delta):
	var player_in_range = get_overlapping_bodies()
	if player_in_range.size() > 0:
		look_at(player.global_position)  # Enemy faces the player

func shoot():
	var num_bullets = 5  # Total bullets per shot
	var spread_angle = deg_to_rad(30)  # Total angle spread (30 degrees)
	var center_angle = rotation  # The enemy's current facing direction

	for i in range(num_bullets):
		var offset = (i - (num_bullets - 1) / 2.0) * spread_angle  # Spread bullets symmetrically
		fire_bullet(center_angle + offset)  # Shoot each bullet in the calculated direction

func fire_bullet(angle):
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = shooting_point.global_position
	new_bullet.rotation = angle  # Rotate bullet correctly
	get_parent().add_child(new_bullet)

func _on_timer_timeout():
	shoot()
