extends CharacterBody3D

signal item_capture(node)

var start_process = false
# ....
var MAX_SPEED = 10
# ....
var bubble_scn = preload("res://weapons/bubble_bullet.tscn")
var triggered = false


func _physics_process(delta):
	if start_process:
		var collision_info = move_and_collide(velocity * delta)
		if collision_info:
			var collider = collision_info.get_collider()
			if collider:
				if collider.is_in_group('env'):
					call_deferred('queue_free')
				if collider.is_in_group('scorable'):
					print('HIT ITEM')
					if not triggered:
						collider.desired_motion = Vector3(0, .01, 0)
						collider.add_child(bubble_scn.instantiate())
						collider.trapped = true
						call_deferred('queue_free')
					triggered = true
