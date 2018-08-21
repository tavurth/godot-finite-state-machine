extends "state.gd"

func _input(event):
	# Start patrolling when the player gets closer to us
	if target.distance_from_player() < 50000:
		state_machine.transition("patrol")

func _on_enter_state():
	# Unequip weapon
	target.set_mode("peace")
