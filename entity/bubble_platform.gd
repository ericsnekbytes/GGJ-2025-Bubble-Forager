extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()


func _on_timer_timeout():
	call_deferred('queue_free')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
