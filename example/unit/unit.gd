extends Node2D

const StateMachineFactory = preload("../../addons/godot-finite-state-machine/state_machine_factory.gd")
const IdleState = preload("idle_state.gd")
const PatrolState = preload("patrol_state.gd")
const AttackState = preload("attack_state.gd")

onready var smf = StateMachineFactory.new()
onready var Player = get_node('/root/World/Player')

var enemy = false
var lastShootingTime = 0

var brain

##
## This is required so that our FSM can handle updates
func _input(event): brain._input(event)
func _process(delta): brain._process(delta)

func _ready():
	brain = smf.create({
		"target": self,
		"current_state": "idle",
		"states": [
			{"id": "idle", "state": IdleState},
			{"id": "patrol", "state": PatrolState},
			{"id": "attack", "state": AttackState}
		],
		"transitions": [
			{"state_id": "idle", "to_states": ["patrol", "attack"]},
			{"state_id": "patrol", "to_states": ["idle", "attack"]},
			{"state_id": "attack", "to_states": ["idle", "patrol"]}
		]
	})

	set_process(true)
	set_process_input(true)

func distance_from_player():
	"""
	Returns the distance^2 to the players position
	"""
	return self.transform.origin.distance_squared_to(Player.transform.origin)

func find_enemies():
	"""
	If we're close to the player, set them as our primary enemy
	"""
	if distance_from_player() < 20000:
		enemy = Player
		return

	enemy = false

func has_enemies():
	"""
	Returns true if we previously saw the player close to us
	"""
	return enemy

func can_shoot():
	"""
	We should not be able to always fire at the player
	This function only returns true when some time has passed since the last shot
	"""
	var currentTime = OS.get_system_time_secs()
	return currentTime - lastShootingTime > 0

func attack_target():
	"""
	Fire at the player if we're reloaded and update the time we shot last
	"""
	if not can_shoot():
		return

	lastShootingTime = OS.get_system_time_secs()
	print("Shooting at player")

func set_mode(newMode):
	print('Set mode: ', newMode)
