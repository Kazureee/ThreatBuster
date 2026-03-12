extends Area2D

func _physics_process(_delta):
	var enemies_in_range = get_overlapping_bodies()
	
	if enemies_in_range.size() > 0:
		var nearest_enemy = find_nearest_enemy(enemies_in_range)
		if nearest_enemy:
			$WeaponPivot/ESET/ShootingPoint.look_at(nearest_enemy.global_position)

func find_nearest_enemy(enemies):
	var nearest_enemy = null
	var shortest_distance = INF  # Start with an infinite distance

	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < shortest_distance:
			shortest_distance = distance
			nearest_enemy = enemy

	return nearest_enemy

func shoot():
	const BULLET = preload("res://Turret/turret_bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	get_parent().add_child(new_bullet)  # Add to the scene root

func _on_timer_timeout():
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		shoot()

var weapon_range: float

func _ready():
	weapon_range = Global.weapon_range  # Get the initial weapon range from the global script
	set_range(weapon_range)

func set_range(new_range: float):
	weapon_range = new_range
	Global.weapon_range = weapon_range  # Update the global variable
	var shape = $Range.shape as CircleShape2D
	if shape:
		shape.radius = weapon_range

func increase_range(amount: float):
	set_range(weapon_range + amount)
	
