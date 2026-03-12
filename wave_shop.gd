extends CanvasLayer

@onready var perk_selection = $PerkSelection  # Path to the VBoxContainer or GridContainer
@onready var continue_button = $ContinueButton  # Path to the Continue button

# Define all perks with their rarity (1-10) and effects
var perks = [
	# Original perks (without Base Damage)
	{"name": "+10% Speed", "effect": "increase_speed", "value": Global.player_speed * 0.1, "rarity": 5},
	{"name": "+15% Max Health", "effect": "increase_health", "value": Global.player_max_health * 0.15, "rarity": 5},
	
	# New point-based perks
	{"name": "+1 Malwarebytes", "effect": "increase_malwarebytes", "value": 1, "rarity": 3},
	{"name": "+2 Malwarebytes", "effect": "increase_malwarebytes", "value": 2, "rarity": 2},
	{"name": "+3 Malwarebytes", "effect": "increase_malwarebytes", "value": 3, "rarity": 1},
	{"name": "+1 ESET", "effect": "increase_eset", "value": 1, "rarity": 3},
	{"name": "+2 ESET", "effect": "increase_eset", "value": 2, "rarity": 2},
	{"name": "+3 ESET", "effect": "increase_eset", "value": 3, "rarity": 1},
	{"name": "+1 Cloudflare", "effect": "increase_cloudflare", "value": 1, "rarity": 3},
	{"name": "+2 Cloudflare", "effect": "increase_cloudflare", "value": 2, "rarity": 2},
	{"name": "+3 Cloudflare", "effect": "increase_cloudflare", "value": 3, "rarity": 1},
	{"name": "+1 OWASP", "effect": "increase_owasp", "value": 1, "rarity": 3},
	{"name": "+2 OWASP", "effect": "increase_owasp", "value": 2, "rarity": 2},
	{"name": "+3 OWASP", "effect": "increase_owasp", "value": 3, "rarity": 1}
]

func _ready():
	# Display available perks
	display_perks()

	# Disconnect the signal if it's already connected
	if continue_button.is_connected("pressed", Callable(self, "_on_continue_button_pressed")):
		continue_button.disconnect("pressed", Callable(self, "_on_continue_button_pressed"))

	# Connect the "pressed" signal to the handler function
	continue_button.connect("pressed", Callable(self, "_on_continue_button_pressed"))

# Display perks as buttons based on rarity
func display_perks():
	# Clear existing buttons
	for child in perk_selection.get_children():
		perk_selection.remove_child(child)

	# Select 4 random perks based on rarity
	var selected_perks = select_perks_by_rarity(4)

	# Create buttons for the selected perks
	for perk in selected_perks:
		var button = Button.new()
		button.text = perk["name"]
		button.connect("pressed", Callable(self, "_on_perk_selected").bind(perk))
		perk_selection.add_child(button)

# Select perks based on rarity (weighted random)
func select_perks_by_rarity(count: int) -> Array:
	var selected_perks = []
	var total_weight = 0

	# Calculate total weight based on rarity
	for perk in perks:
		total_weight += perk["rarity"]

	# Select perks
	for i in range(count):
		var random_value = randi() % total_weight
		var cumulative_weight = 0

		for perk in perks:
			cumulative_weight += perk["rarity"]
			if random_value < cumulative_weight:
				selected_perks.append(perk)
				total_weight -= perk["rarity"]  # Remove this perk's weight to avoid duplicates
				perks.erase(perk)  # Remove the perk from the list to avoid duplicates
				break

	return selected_perks

# Handle perk selection
func _on_perk_selected(perk):
	print("Selected perk: ", perk["name"])

	# Apply the perk effect to the player
	match perk["effect"]:
		"increase_speed":
			Global.player_speed += perk["value"]
			Global.player_speed = Global.player_speed  # Keep actual speed updated
			print("Player speed increased to: ", Global.player_speed)
		"increase_health":
			Global.player_max_health += perk["value"]
			Global.player_health = Global.player_max_health  # Ensure current health matches max health
			print("Player max health increased to: ", Global.player_max_health)
		"increase_malwarebytes":
			Global.player_Malwarebytes += perk["value"]
			print("Player Malwarebytes increased to: ", Global.player_Malwarebytes)
		"increase_eset":
			Global.player_ESET += perk["value"]
			print("Player ESET increased to: ", Global.player_ESET)
		"increase_cloudflare":
			Global.player_Cloudflare += perk["value"]
			print("Player Cloudflare increased to: ", Global.player_Cloudflare)
		"increase_owasp":
			Global.player_OWASP += perk["value"]
			print("Player OWASP increased to: ", Global.player_OWASP)
			
	Global.update_stat()
	
	# Remove all buttons after selection to prevent duplicate selections
	for child in perk_selection.get_children():
		perk_selection.remove_child(child)

func _on_continue_button_pressed() -> void:
	%Status.visible = true
	get_tree().change_scene_to_file("res://shop.tscn")
	
