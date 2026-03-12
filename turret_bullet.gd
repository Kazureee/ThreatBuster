extends Area2D

# Apply 1.5x multiplier to each variable
var Malwarebytes = Global.player_Malwarebytes * 1.5
var ESET = Global.player_ESET * 1.5
var Cloudflare = Global.player_Cloudflare * 1.5
var OWASP = Global.player_OWASP * 1.5

var travelled_distance = 0
var attack_name = "Basic Bullet"
var is_Malwarebytes = true 
var is_ESET = true          
var is_Cloudflare = true    
var is_OWASP = true        

# Calculate damage with the multipliers applied
func get_damage() -> int:
	return Malwarebytes + ESET + Cloudflare + OWASP  # Includes the 1.5x multipliers


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
		var total_attack_name = attack_name + " Malwarebytes + ESET + Cloudflare + OWASP ModSecurity"
		body.take_damage(get_damage(), total_attack_name)  # Pass the scaled damage to the enemy
