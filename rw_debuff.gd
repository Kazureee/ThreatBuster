extends CanvasLayer

@onready var pay_button = $Label/PayButton  # Reference to the Pay button

func _ready():
	
	hide()  # Hide UI by default
	Global.connect("coins_updated", Callable(self, "update_pay_button"))  # Update button when coins change

func show_prompt():
	show()  # Show UI
	await get_tree().process_frame  # Wait for UI to update
	update_pay_button()  # Ensure button is enabled/disabled properly

func update_pay_button(_coins = null):  # Accept an optional argument
	var debuff_cost = 50
	if Global.player_coins < debuff_cost:
		pay_button.disabled = true
	else:
		pay_button.disabled = false

func _on_pay_button_pressed():
	var ransomware = get_ransomware()

	if ransomware and Global.player_coins >= 50:
		print("Paying to remove debuff...")
		ransomware.pay_to_remove_debuff()
		update_pay_button()  # Immediately update button state
		hide()
	else:
		print("Not enough coins! Pay button should be disabled.")

func get_ransomware():
	var ransomware_nodes = get_tree().get_nodes_in_group("ransomware")
	return ransomware_nodes.front() if ransomware_nodes else null
