extends CharacterBody3D

var player_id = -1
var start_process = false
# ....
@onready var player_cam = $Camera3D
# ....
var MAX_THRUST = 300
var GRAVITY_BASE = Vector3(0, -9.8, 0)
var MAX_SPEED = 54
# ....
var MAX_SPIN = PI
var MAX_PITCH = PI


func _unhandled_input(event):
	pass


func _physics_process(delta):
	if start_process:
		var start_velocity = velocity
		var motion_vector = Vector3.ZERO

		var player_commands = InputHandler.get_command_dict(player_id)
		print(player_commands)

		var move_forward_back = Vector3.ZERO
		if player_commands['move_yaxis'] != null:
			move_forward_back = player_cam.basis.z.normalized() * MAX_THRUST * player_commands['move_yaxis']
			print('FWDBK %s // %s' % [player_commands['move_yaxis'], move_forward_back])

		var move_left_right = Vector3.ZERO
		if player_commands['move_xaxis'] != null:
			move_left_right = player_cam.basis.x.normalized() * MAX_THRUST * player_commands['move_xaxis']
			print('HORZ %s // %s' % [player_commands['move_xaxis'], move_forward_back])

		var look_spin = 0
		var look_spin_raw = player_commands['look_xaxis']
		if look_spin_raw != null:
			look_spin_raw *= -1
			if abs(look_spin_raw) > .2:
				look_spin = look_spin_raw * MAX_SPIN
			print('SPIN %s // %s' % [look_spin, look_spin_raw])

		var look_pitch = 0
		var look_pitch_raw = player_commands['look_yaxis']
		if look_pitch_raw != null:
			look_pitch_raw *= -1
			if abs(look_pitch_raw) > .2:
				look_pitch = look_pitch_raw * MAX_PITCH
			print('PITCH %s // %s' % [look_pitch, look_pitch_raw])

		var ground_motion = move_left_right + move_forward_back
		if ground_motion.length() > MAX_THRUST:
			ground_motion = ground_motion.normalized() * MAX_THRUST

		# Add gravity vector
		var gravity_vec = GRAVITY_BASE

		player_cam.transform = player_cam.transform.orthonormalized()
		player_cam.rotate(player_cam.basis.x, look_pitch * delta)
		player_cam.rotate(Vector3(0, 1, 0), look_spin * delta)

		# Sum up motion  # TODO
		motion_vector = gravity_vec + (ground_motion * delta)
		#motion_vector.y = (
			#motion_vector.x,
			#motion_vector.y * 1.01,
			#motion_vector.x,
		#)
		if motion_vector.length() > MAX_SPEED:
			motion_vector = motion_vector.normalized() * MAX_SPEED

		velocity = motion_vector

		move_and_slide()
