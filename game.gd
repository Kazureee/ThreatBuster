extends Node2D

@onready var game_over_layer = %GameOver 
@onready var pause_menu = $"UI Layer/PauseMenu"  
@onready var path_follow = %PathFollow2D  
@onready var spawn_timer = $SpawnTimer  
@onready var spawn_interval_timer = $Spawn  
@onready var timer_label = $"UI Layer/Status/Control/TimerLabel" 
@onready var wave_label = $"UI Layer/Status/Control/WaveLabel" 
@onready var perks = $"UI Layer/Perks"
@onready var email = $"UI Layer/PhishingEmail"
@onready var alert = preload("res://UI/Alert.tscn").instantiate()
var cyberworm_wave11_20_timer: Timer = null

var is_wave_active = false  # Track if a wave is currently active
var ransomware_spawned = false  # Flag to track if the ransomware golem has spawned this wave
var crypto_jackers_in_game = 0  # Track the number of CryptoJackers currently in the game
var cyber_worms_spawned = 0  # Track CyberWorms spawned
var cyberworm_timer = null  # Timer for wave 10 CyberWorm spawns
var adware_spawned = 0
var boss_spawned = false
var spyware_timer  

func _ready():
	reset_shown_alerts()
	game_over_layer.visible = false
	pause_menu.visible = false
	
	# Initialize UI
	timer_label.text = "Time until next wave: 0s"
	wave_label.text = "Wave: " + str(Global.wave_count) + " / " + str(Global.max_waves)
	
	# Add the alert to the scene
	add_child(alert)
	
	if not is_wave_active:
		start_wave()


func start_wave():
	if Global.wave_count < Global.max_waves:
		# Ensure the game is not paused before starting a new wave
		get_tree().paused = false 
		
		# Increment wave count only if a wave is not already active
		if not is_wave_active:
			Global.wave_count += 1
		
		# Update UI
		wave_label.text = "Wave: " + str(Global.wave_count) + " / " + str(Global.max_waves)
		is_wave_active = true
		ransomware_spawned = false  # Reset ransomware spawn flag for the new wave
		crypto_jackers_in_game = 0  # Reset CryptoJacker count for the new wave


		# Show Virus alert at the beginning of Wave 1 (and resume the game after 5 seconds)
		if Global.wave_count == 1 and not shown_alerts["Virus"]:
			shown_alerts["Virus"] = true
			alert.show_alert(preload("res://Photo/Alert/Virus.png"), true)  # Pass true to resume the game

		# Handle phishing email transition
		start_wave_timers()
	else:
		# Stop spawning after the last wave
		spawn_timer.stop()
		spawn_interval_timer.stop()
		timer_label.text = "Spawning complete!"
		transition_to_victory()


func start_wave_timers():
	# Calculate the timer duration for the current wave
	var wave_time = Global.base_wave_time * pow(Global.wave_time_multiplier, Global.wave_count - 1)
	spawn_timer.wait_time = wave_time
	spawn_timer.start()
	
	# Start spawning mobs at regular intervals
	spawn_interval_timer.start()

func spawn_mob():
	# Spawn Virus only from wave 1 to 9
	if Global.wave_count <= 9:
		var virus_scene = preload("res://enemy/weak/virus/virus.tscn")
		var virus = virus_scene.instantiate()
		path_follow.progress_ratio = randf()  # Randomize position
		virus.global_position = path_follow.global_position
		add_child(virus)

	# Spawn Adware in specific waves (4, 7, 12, 16, 19)
	if Global.wave_count in [4, 7, 12,15, 16, 19] and adware_spawned < 1:
		var adware_scene = preload("res://enemy/weak/Adware/adware.tscn")
		var adware = adware_scene.instantiate()
		adware.global_position = path_follow.global_position
		add_child(adware)
		adware_spawned += 1
		adware.connect("tree_exited", Callable(self, "_on_adware_died"))  # Track when Adware dies

	# Spawn CryptoJacker in specific waves (3, 4, 6, 7, 8, 9, 11, 12, 13, 14, 16, 17, 18, 19)
	if Global.wave_count in [3, 4, 6, 7, 8, 9, 11, 12, 13, 14, 16, 17, 18, 19]:
		if crypto_jackers_in_game < 3:
			var crypto_jacker_scene = preload("res://enemy/elite/CryptoJacker/crypto_jacker.tscn")
			var crypto_jacker = crypto_jacker_scene.instantiate()
			crypto_jacker.global_position = path_follow.global_position
			add_child(crypto_jacker)
			crypto_jackers_in_game += 1
			crypto_jacker.connect("tree_exited", Callable(self, "_on_crypto_jacker_died"))

	# Spawn Ransomware in waves 5, 15
	if Global.wave_count in [5, 15] and not ransomware_spawned:
		var ransomware_golem_scene = preload("res://enemy/elite/Ransomware/ransomware.tscn")
		var ransomware_golem = ransomware_golem_scene.instantiate()
		ransomware_golem.global_position = path_follow.global_position
		add_child(ransomware_golem)
		ransomware_spawned = true

	# Spawn Spyware in waves 13+
	if Global.wave_count >= 13:
		if spyware_timer == null:
			spyware_timer = Timer.new()
			spyware_timer.wait_time = 3.0  # Set to 3 seconds
			spyware_timer.one_shot = false  # Repeat indefinitely
			spyware_timer.connect("timeout", Callable(self, "_spawn_spyware"))  # Call function every 3s
			add_child(spyware_timer)
			spyware_timer.start()

	# Spawn CyberWorm in wave 10
	if Global.wave_count == 10:
		if cyberworm_timer == null:
			cyberworm_timer = Timer.new()
			cyberworm_timer.wait_time = 2.0  # Spawn every 2 seconds
			cyberworm_timer.one_shot = false
			cyberworm_timer.connect("timeout", Callable(self, "_spawn_cyberworm_wave10"))
			add_child(cyberworm_timer)
			cyberworm_timer.start()

	# Spawn CyberWorm from wave 11 to 20 every 5 seconds
	if Global.wave_count >= 11 and Global.wave_count <= 20:
		if cyberworm_wave11_20_timer == null:
			cyberworm_wave11_20_timer = Timer.new()
			cyberworm_wave11_20_timer.wait_time = 5.0  # Spawn every 5 seconds
			cyberworm_wave11_20_timer.one_shot = false
			cyberworm_wave11_20_timer.connect("timeout", Callable(self, "_spawn_cyberworm_wave11_20"))
			add_child(cyberworm_wave11_20_timer)
			cyberworm_wave11_20_timer.start()

	# Spawn SQL Injection Boss in wave 15
	if Global.wave_count == 15 and not boss_spawned:
		var boss_path = "res://enemy/boss/SQL Injection/SQL_Injection.tscn"
		var boss_scene = load(boss_path)
		if boss_scene:
			var boss = boss_scene.instantiate()
			boss.global_position = path_follow.global_position
			add_child(boss)
			boss_spawned = true

	# Spawn DDoS Boss in wave 20
	if Global.wave_count == 20 and not boss_spawned:
		var boss_path = "res://enemy/boss/DDoS/d_do_s.tscn"
		var boss_scene = load(boss_path)
		if boss_scene:
			var boss = boss_scene.instantiate()
			boss.global_position = path_follow.global_position
			add_child(boss)
			boss_spawned = true

func _spawn_spyware():
	var spyware_scene = preload("res://enemy/elite/Spyware/spyware.tscn")
	var spyware = spyware_scene.instantiate()
	spyware.global_position = path_follow.global_position
	add_child(spyware)

func _spawn_cyberworm_wave10():
	# Stop spawning if already reached 11 CyberWorms
	if cyber_worms_spawned >= 11:
		cyberworm_timer.stop()
		cyberworm_timer.queue_free()
		cyberworm_timer = null
		return  # Stop execution

	for i in range(2):  # Spawn 2 at a time
		if cyber_worms_spawned < 11:
			var cyber_worm_scene = preload("res://enemy/elite/CyberWorm/cyber_worm.tscn")
			var cyber_worm = cyber_worm_scene.instantiate()

			# Spread the spawn locations randomly within a range
			var random_offset = Vector2(randf_range(-200, 200), randf_range(-150, 150))
			cyber_worm.global_position = path_follow.global_position + random_offset

			add_child(cyber_worm)
			cyber_worms_spawned += 1
			cyber_worm.connect("tree_exited", Callable(self, "_on_cyber_worm_died"))

func _spawn_cyberworm_wave11_20():
	var cyber_worm_scene = preload("res://enemy/elite/CyberWorm/cyber_worm.tscn")
	var cyber_worm = cyber_worm_scene.instantiate()

	# Spread the spawn locations randomly within a range
	var random_offset = Vector2(randf_range(-200, 200), randf_range(-150, 150))
	cyber_worm.global_position = path_follow.global_position + random_offset

	add_child(cyber_worm)
	cyber_worm.connect("tree_exited", Callable(self, "_on_cyber_worm_died"))

func _on_cyber_worm_died():
	# CyberWorms do NOT respawn if they die
	pass

func _on_adware_died():
	# CyberWorms do NOT respawn if they die
	pass

func _on_crypto_jacker_died():
	# Decrement the CryptoJacker count when one dies
	crypto_jackers_in_game -= 1

func transition_to_victory():
	# Transition to victory screen or end game logic
	print("All waves completed! Victory!")
	# Example: get_tree().change_scene_to_file("res://victory_screen.tscn")
func show_phishing_email():
	# Transition to the phishing email scene using the preloaded scene
	get_tree().paused = true  
	email.visible = true

func show_perks():
	get_tree().paused = true
	%Status.visible = false
	%Stats.visible = true
	%Perks.visible = true
func show_store():
	get_tree().change_scene_to_file("res://shop.tscn")
	
func _on_spawn_timer_timeout():
	is_wave_active = false
	spawn_interval_timer.stop()  # Stop spawning mobs
	timer_label.text = "Time to shop!"

	# Show alerts for the next wave
	show_alert_for_next_wave()

	# Wait for the alert to finish (5 seconds), then show perks or phishing email
	await get_tree().create_timer(5).timeout  # Wait for 5 seconds (duration of the alert)

	# Check if the current wave is 4, 9, 14, or 19
	if Global.wave_count in [1,4, 9, 14, 19]:
		# Transition to phishing email scene
		show_phishing_email()
	else:
		# Transition to the perks screen (WaveShop.tscn)
		show_perks()

func _process(delta):
	if is_wave_active and spawn_timer.time_left > 0:
		timer_label.text = "Time until next wave: " + str(int(spawn_timer.time_left)) + "s"

func _on_player_health_depleted() -> void:
	get_tree().paused = true  
	game_over_layer.visible = true  

func _on_pause_pressed() -> void:
	hide()
	pause_menu.visible = true
	get_tree().paused = true

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")
	Global.reset_game()

func _on_restart_pressed() -> void:
	# Reset the game state
	Global.reset_game()
	
	# Unpause the game and reload the scene
	get_tree().paused = false
	get_tree().change_scene_to_file("res://game.tscn")

func _on_spawn_timeout() -> void:
	if is_wave_active:
		spawn_mob()
var shown_alerts = {
	"Virus": false,
	"Adware": false,
	"CyberWorm": false,
	"CryptoJacker": false,
	"Ransomware": false,
	"Spyware": false,
	"SQLInjectionBoss": false,  
	"DDoSBoss": false           
}

func show_alert_for_next_wave():
	# Calculate the next wave
	var next_wave = Global.wave_count

	# Show alerts based on the next wave
	match next_wave:
		2:  # CryptoJacker alert for Wave 2 (spawns in Wave 3)
			if not shown_alerts["CryptoJacker"]:
				shown_alerts["CryptoJacker"] = true
				alert.show_alert(preload("res://Photo/Alert/CryptoJacker.png"), false)  # Pass false to not resume the game
		3:  # Adware alert for Wave 3 (spawns in Wave 4)
			if not shown_alerts["Adware"]:
				shown_alerts["Adware"] = true
				alert.show_alert(preload("res://Photo/Alert/Adware.png"), false)  # Pass false to not resume the game
		4:  # Ransomware alert for Wave 4 (spawns in Wave 5)
			if not shown_alerts["Ransomware"]:
				shown_alerts["Ransomware"] = true
				alert.show_alert(preload("res://Photo/Alert/Ransomware.png"), false)  # Pass false to not resume the game
		9:  # CyberWorm alert for Wave 9 (spawns in Wave 10)
			if not shown_alerts["CyberWorm"]:
				shown_alerts["CyberWorm"] = true
				alert.show_alert(preload("res://Photo/Alert/CyberWorm.png"), false)  # Pass false to not resume the game
		12:  # Spyware alert for Wave 12 (spawns in Wave 13)
			if not shown_alerts["Spyware"]:
				shown_alerts["Spyware"] = true
				alert.show_alert(preload("res://Photo/Alert/Spyware.png"), false)  # Pass false to not resume the game
		14:  # SQL Injection Boss alert for Wave 14 (spawns in Wave 15)
			if not shown_alerts["SQLInjectionBoss"]:
				shown_alerts["SQLInjectionBoss"] = true
				alert.show_alert(preload("res://Photo/Alert/SQL Injection.png"), false)  # Pass false to not resume the game
		19:  # DDoS Boss alert for Wave 19 (spawns in Wave 20)
			if not shown_alerts["DDoSBoss"]:
				shown_alerts["DDoSBoss"] = true
				alert.show_alert(preload("res://Photo/Alert/DDoS.png"), false)  # Pass false to not resume the game
				
func reset_shown_alerts():
	shown_alerts = {
		"Virus": false,
		"Adware": false,
		"CyberWorm": false,
		"CryptoJacker": false,
		"Ransomware": false,
		"Spyware": false,
		"SQLInjectionBoss": false, 
		"DDoSBoss": false          
	}
