extends Control

# Reference to the labels in the scene
@onready var max_health_label: Label = $VBoxContainer/MaxHealthLabel
@onready var speed_label: Label = $VBoxContainer/SpeedLabel
@onready var base_damage_label: Label = $VBoxContainer/BaseDamageLabel
@onready var weapon_range_label: Label = $VBoxContainer/WeaponRangeLabel
@onready var malwarebytes_label: Label = $VBoxContainer/MalwarebytesLabel
@onready var eset_label: Label = $VBoxContainer/ESETLabel
@onready var cloudflare_label: Label = $VBoxContainer/CloudflareLabel
@onready var owasp_label: Label = $VBoxContainer/OWASPLabel
@onready var defense_label: Label = $VBoxContainer/DefenseLabel

func _ready():
	Global.connect("stats_updated", Callable(self, "update_stats"))
	update_stats()
	
func update_stats():
	max_health_label.text = "Max Health: " + str(Global.player_max_health)
	speed_label.text = "Speed: " + str(Global.player_speed)
	defense_label.text = "Defense: " + str(Global.player_def)
	base_damage_label.text = "Base Damage: " + str(Global.player_base_damage)
	weapon_range_label.text = "Weapon Range: " + str(Global.weapon_range)
	malwarebytes_label.text = "Malwarebytes Dmg: " + str(Global.player_Malwarebytes)
	eset_label.text = "ESET Dmg: " + str(Global.player_ESET)
	cloudflare_label.text = "Cloudflare Dmg: " + str(Global.player_Cloudflare)
	owasp_label.text = "OWASP Dmg: " + str(Global.player_OWASP)
