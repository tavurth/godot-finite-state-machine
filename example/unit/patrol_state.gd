extends "state.gd"

var patrolDirection = Vector2(1, 1)

var PATROL_MAX_X = 600
var PATROL_MIN_X = 400

var PATROL_MAX_Y = 400
var PATROL_MIN_Y = 200

func check_for_new_patrol_direction(position):
	"""
	Checks to see whether the unit has left the bounds in one
	direction or the other.

	If the unit is outside bounds, reverse it's walking direction for that axis
	"""
	if position.x > PATROL_MAX_X or position.x < PATROL_MIN_X:
		patrolDirection *= Vector2(-1, 1)

	if position.y > PATROL_MAX_Y or position.y < PATROL_MIN_Y:
		patrolDirection *= Vector2(1, -1)

func _process(delta):
	check_for_new_patrol_direction(target.transform.origin)

	# Move target along a path
	target.transform.origin += patrolDirection
	target.find_enemies()

	if target.has_enemies():
		state_machine.transition("attack")

func _input(event):
	# We're far from the player, stop patrolling
	if target.distance_from_player() > 100000:
		state_machine.transition("idle")

func _on_enter_state():
	# Equip weapon
	target.set_mode("patrolling")

func _on_leave_state():
	pass
