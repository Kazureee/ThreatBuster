extends Area2D

var Malwarebytes = Global.player_Malwarebytes
var ESET = Global.player_ESET
var Cloudflare = Global.player_Cloudflare
var OWASP = Global.player_OWASP

var travelled_distance = 0
var attack_name = "Basic Bullet"
var is_Malwarebytes = true 
var is_ESET = true          
var is_Cloudflare = true    
var is_OWASP = true        

# Damage is now fetched from Global.gd
func get_damage() -> int:
	var damage = Global.player_base_damage  # Always start with base damage
	if is_Malwarebytes:
		# Calculate Malwarebytes damage: base damage * (1.1 ^ malware damage)
		Malwarebytes *= (1 + 0.2 * damage)
	if is_ESET:
		# Calculate ESET damage: base damage * (1.2 ^ ESET damage)
		ESET *= (1 + 0.2 * damage)
	if is_Cloudflare:
		# Calculate Cloudflare damage: base damage * (1.15 ^ Cloudflare damage)
		Cloudflare *= (1 + 0.2 * damage)
	if is_OWASP:
		# Calculate OWASP ModSecurity damage: base damage * (1.25 ^ OWASP damage)
		OWASP *= (1 + 0.2 * damage)
	return damage
	
func _physics_process(delta: float) -> void:
	const SPEED = 1000
	const RANGE = 1000
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	queue_free()
	if body.has_method("take_damage"):
		# Apply damage based on all attack types
		var total_attack_name = attack_name + " Malwarebytes + ESET + Cloudflare + OWASP ModSecurity"
		body.take_damage(get_damage(), total_attack_name)  # Apply all attack types
