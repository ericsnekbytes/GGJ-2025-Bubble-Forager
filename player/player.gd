extends CharacterBody3D

var player_id = -1:
	set(value):
		player_id = value
		for gun in [$Camera3D/WeaponPivot/GunHairDryer, $Camera3D/WeaponPivot/GunBubble]:
			gun.owning_player = self
var start_process = false
# ....
@onready var player_cam = $Camera3D
@onready var start_basis = global_basis
# ....
var MAX_THRUST = 750
var GRAVITY_BASE = Vector3(0, -9.8, 0)
var MAX_SPEED = 54
# ....
var MAX_SPIN = PI
var MAX_PITCH = PI
# ....
var last_jump_timestamp = 0
var jump_cooldown = 500
var jump_strength = 2500
var jump_vector = Vector3(0, jump_strength, 0)
@onready var jump_timer = $JumpTimer
# ....
@onready var gun_hair_dryer = $Camera3D/WeaponPivot/GunHairDryer
@onready var gun_bubble = $Camera3D/WeaponPivot/GunBubble
#@onready var active_weapon = $Camera3D/WeaponPivot/GunBubble.weapon_id
#@onready var weapons = {
	#$Camera3D/WeaponPivot/GunHairDryer.weapon_id: $Camera3D/WeaponPivot/GunHairDryer,
	#$Camera3D/WeaponPivot/GunBubble.weapon_id: $Camera3D/WeaponPivot/GunBubble,
#}


func _ready():
	# Configure guns
	gun_bubble.start_process = true
	gun_hair_dryer.set_raycast_orientation(player_cam)
	gun_hair_dryer.raycast_exclude(self)


func _unhandled_input(event):
	var current_time = Time.get_ticks_msec()

	var pdev = InputHandler.get_player_device(player_id)
	if event.device == pdev:
		if event.is_pressed() and event.is_action('jump'):
			print('JUMP')
			if current_time - last_jump_timestamp > jump_cooldown:
				jump_timer.start()
			last_jump_timestamp = current_time
		if event.is_pressed() and event.is_action('swap_gun'):
			if not gun_hair_dryer.visible:
				gun_hair_dryer.show()
				gun_hair_dryer.start_process = true

				gun_bubble.start_process = false
				gun_bubble.hide()
			else:
				gun_hair_dryer.hide()
				gun_hair_dryer.start_process = false

				gun_bubble.start_process = true
				gun_bubble.show()


func _physics_process(delta):
	if start_process:
		var start_velocity = velocity
		var motion_vector = Vector3.ZERO

		var player_commands = InputHandler.get_command_dict(player_id)
		#print(player_commands)

		var move_forward_back = Vector3.ZERO
		var move_fwd_back_raw = player_commands['move_yaxis']
		if move_fwd_back_raw != null and abs(move_fwd_back_raw) > .2:
			move_forward_back = player_cam.basis.z.normalized() * MAX_THRUST * move_fwd_back_raw
			#print('FWDBK %s // %s' % [move_fwd_back_raw, move_forward_back])

		var move_left_right = Vector3.ZERO
		var move_left_right_raw = player_commands['move_xaxis']
		if move_left_right_raw != null and abs(move_left_right_raw) > .2:
			move_left_right = player_cam.basis.x.normalized() * MAX_THRUST * move_left_right_raw
			#print('HORZ %s // %s' % [move_left_right_raw, move_forward_back])

		var look_spin = 0
		var look_spin_raw = player_commands['look_xaxis']
		if look_spin_raw != null and abs(look_spin_raw) > .2:
			look_spin_raw *= -1
			look_spin = look_spin_raw * MAX_SPIN
			#print('SPIN %s // %s' % [look_spin, look_spin_raw])

		var look_pitch = 0
		var look_pitch_raw = player_commands['look_yaxis']
		if look_pitch_raw != null and abs(look_pitch_raw) > .2:
			look_pitch_raw *= -1
			look_pitch = look_pitch_raw * MAX_PITCH
			#print('PITCH %s // %s' % [look_pitch, look_pitch_raw])

		var ground_motion = move_left_right + move_forward_back
		if ground_motion.length() > MAX_THRUST:
			ground_motion = ground_motion.normalized() * MAX_THRUST

		# Add gravity vector
		var gravity_vec = GRAVITY_BASE

		player_cam.transform = player_cam.transform.orthonormalized()
		player_cam.rotate(player_cam.basis.x, look_pitch * delta)
		player_cam.rotate(Vector3(0, 1, 0), look_spin * delta)

		# Add inertia
		#var drag_losses = .9
		#var drag_fraction_instantaneous = 1 - (drag_losses * delta)
		var inertia = start_velocity
		#var vertical_motion = inertia.y
		#var gravity_effect = .01
		#var gravity_multiplier = 1 + (gravity_effect * delta)
		#if vertical_motion < 0:
			#gravity_multiplier = 1 / (gravity_effect * delta)
		#vertical_motion *= gravity_multiplier
		#inertia.y = vertical_motion
		
		var jump_instantaneous = Vector3.ZERO
		if not jump_timer.is_stopped():
			jump_instantaneous = jump_vector * (jump_timer.time_left / jump_timer.wait_time)

		# Sum up motion  # TODO
		motion_vector = gravity_vec + (delta * (ground_motion + jump_instantaneous))
		if motion_vector.length() > MAX_SPEED:
			motion_vector = motion_vector.normalized() * MAX_SPEED
		# Add fake exponential gravity
		var vertical_motion = motion_vector.y
		if vertical_motion < 0:
			vertical_motion *= 1 + (.01 * delta)
		else:
			vertical_motion *= 1 / (.01 * delta)

		velocity = motion_vector

		move_and_slide()
