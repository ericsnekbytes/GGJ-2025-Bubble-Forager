extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()


func _on_timer_timeout():
	call_deferred('queue_free')


func _on_area_3d_body_exited(body):
	# Destroy platform when player jumps off
	if body.is_in_group('player'):
		call_deferred('queue_free')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
