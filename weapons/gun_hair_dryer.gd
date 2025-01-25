extends Node3D

var owning_player = null
var weapon_id = 'GUN_HAIR_DRYER'
var start_process = false
# ....
@onready var raycast = $RayCast3D
var firing = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _unhandled_input(event):
	if start_process:
		var player_device = InputHandler.get_player_device(owning_player.player_id)
		#print('SH %s // %s // %s // %s' % [owning_player, player_device, event.device, event.is_action('rtrigger')])
		if owning_player != null and player_device != null and event.device != null and event.device == player_device:
			if event.is_action('rtrigger'):
				if event.is_pressed():
					#print('Firing blow dryer')
					firing = true
				else:
					#print('Stpo firing blow dryer')
					firing = false


func set_raycast_orientation(node):
	raycast.global_position = node.global_position
	raycast.global_basis = node.global_basis
	raycast.global_basis = raycast.global_basis.rotated(raycast.global_basis.x, PI / 2.0)
	#raycast.global_position += node.global_basis.z * -1  # debug


func raycast_exclude(node):
	raycast.add_exception(node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var current_time = Time.get_ticks_msec()
	if start_process:
		var target = raycast.get_collider()
		#print('Raycast %s // %s // %s' % [current_time, target, firing])
		if target:
			#print('HAS tgt %s // %s' % [target, target.is_in_group('scorable')])
			if firing and target.is_in_group('scorable') and target.trapped:
				#print('PUSH ITEM %s' % target)
				target.desired_motion = (owning_player.global_position - target.global_position).normalized() * -.1
