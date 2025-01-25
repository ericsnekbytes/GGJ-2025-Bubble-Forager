extends Node

var tracked_players = {  # Which player owns which device
	#player_id: device_id (starts null)
}
var poll_freq = 200
var last_poll_timestamp = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func add_player(player_id):
	if player_id not in tracked_players:
		tracked_players[player_id] = null


func remove_player(player_id):
	if player_id in tracked_players:
		tracked_players.erase(player_id)


func poll_for_devices():
	var current_time = Time.get_ticks_msec()
	if current_time - last_poll_timestamp >= poll_freq:
		find_and_assign_devices()


func get_player_device(player_id):
	if player_id in tracked_players:
		return tracked_players[player_id]
	else:
		return null


func find_and_assign_devices():
	var all_devs = Input.get_connected_joypads()

	# If there are any devices, check/assign them
	if all_devs:
		# Figure out which players need devices and which devices are taken
		var players_needing_devices = {}
		var assigned_devices = {}
		for pid in tracked_players:
			var player_device = tracked_players[pid]

			if player_device== null:
				players_needing_devices[pid] = null
			else:
				assigned_devices[player_device] = null

		# Assign unused devices to players
		for dev in all_devs:
			var deletion_queue = {}
			if dev not in assigned_devices:
				for pid in players_needing_devices:
					tracked_players[pid] = dev
					assigned_devices[dev] = null
					deletion_queue[pid] = null
					break
			for pid in deletion_queue:
				players_needing_devices.erase(pid)


func get_command_dict(player_id):
	var command_dict = {
		'move_yaxis': null,
		'move_xaxis': null,
		'look_yaxis': null,
		'look_xaxis': null,
	}
	var valid_commands = {
		'move_yaxis': ['AXIS', JOY_AXIS_LEFT_Y],
		'move_xaxis': ['AXIS', JOY_AXIS_LEFT_X],
		'look_yaxis': ['AXIS', JOY_AXIS_RIGHT_Y],
		'look_xaxis': ['AXIS', JOY_AXIS_RIGHT_X],
	}
	if player_id in tracked_players:
		var player_device = tracked_players[player_id]
		if player_device != null:
			for command in valid_commands:
				var command_type = valid_commands[command][0]
				var command_code = valid_commands[command][1]

				if command_type == 'AXIS':
					command_dict[command] = Input.get_joy_axis(player_device, command_code)

	return command_dict
