extends "state.gd"

func _input(event):
	# Command given to move?
	# state_machine.transition("patrol")

	# Command given to stop attacking?
	# state_machine.transition("idle")
	pass

func _process(event):
	target.find_enemies()

	if not target.has_enemies():
		return state_machine.transition("patrol")

	target.attack_target()

func _on_enter_state():
	target.attack_target()

func _on_leave_state():
	pass
