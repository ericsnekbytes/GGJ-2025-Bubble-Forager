extends CharacterBody3D

var MAX_THRUST = 5
var GRAVITY_BASE = Vector3(0, -9.8, 0)
var MAX_SPEED = 54


func _unhandled_input(event):
	pass


func _physics_process(delta):
	var start_velocity = velocity
	var motion_vector = Vector3.ZERO

	# Add gravity vector
	var gravity = GRAVITY_BASE * delta * 1.01

	# Sum up motion  # TODO
	motion_vector = gravity
	if motion_vector.length() > MAX_SPEED:
		motion_vector = motion_vector.normalized() * MAX_SPEED

	velocity += motion_vector

	move_and_slide()
