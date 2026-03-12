extends Area2D

@onready var player = get_node("/root/Game/Player")

func _physics_process(_delta):
	var player_in_range = get_overlapping_bodies()
	if player_in_range.size() > 0:
		var target_player = player_in_range.front()
		look_at(player.global_position)

func shoot():
	const BULLET = preload("res://enemy/elite/CryptoJacker/crypto_bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	get_parent().add_child(new_bullet)  # Add to the scene root

func _on_timer_timeout():
	shoot()
