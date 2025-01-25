extends CharacterBody3D

var MAX_SPEED = 10


func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var collider = collision_info.get_collider()
		if collider:
			print('HIT PLAYER')
			call_deferred('queue_free')
