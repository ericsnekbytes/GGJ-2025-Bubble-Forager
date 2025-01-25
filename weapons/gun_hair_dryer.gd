extends Node3D

var owning_player = null
var weapon_id = 'GUN_HAIR_DRYER'
var start_process = false
# ....
@onready var raycast = $RayCast3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_raycast_orientation(node):
	raycast.global_position = node.global_position
	raycast.global_basis = node.global_basis
	raycast.global_basis = raycast.global_basis.rotated(raycast.global_basis.x, PI / 2.0)
	#raycast.global_position += node.global_basis.z * -1  # debug


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var current_time = Time.get_ticks_msec()
	if start_process:
		print('Raycast %s // %s' % [current_time, raycast.get_collider()])
