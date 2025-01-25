extends CharacterBody3D

var desired_motion = Vector3():
	set(value):
		desired_motion = value
		motion_timer.start()
@onready var motion_timer = $Timer


#func _ready():
	#pass
	#if get_child_count() > 0:
		#get_child(0).get_node('CollisionShape3D').reparent(self)


func _physics_process(delta):
	if not motion_timer.is_stopped():
		move_and_collide(desired_motion * (motion_timer.time_left / motion_timer.wait_time))
