extends Node3D

var start_process = false
var owning_player = null
# ....
var bullet_scn = preload('res://weapons/bubble_bullet.tscn')
@onready var bullet_pivot = $BulletPivot


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	var player_device = InputHandler.get_player_device(owning_player.player_id)
	#print('SH %s // %s // %s // %s' % [owning_player, player_device, event.device, event.is_action('rtrigger')])
	if owning_player != null and player_device != null and event.device == player_device:
		var pcam = owning_player.player_cam
		if event.is_pressed() and event.is_action('rtrigger'):
			#print('Shoot')
			var bullet = bullet_scn.instantiate()
			bullet_pivot.add_child(bullet)
			bullet.global_basis = pcam.global_basis
			bullet.global_position = pcam.global_position + pcam.global_basis.z.rotated(pcam.global_basis.y.normalized(), PI) * 3
			bullet.velocity =  pcam.global_basis.z.rotated(pcam.global_basis.y.normalized(), PI) * bullet.MAX_SPEED
