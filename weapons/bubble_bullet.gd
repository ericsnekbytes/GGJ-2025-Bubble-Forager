extends CharacterBody3D

var MAX_SPEED = 10


func _physics_process(delta):
	move_and_slide()
