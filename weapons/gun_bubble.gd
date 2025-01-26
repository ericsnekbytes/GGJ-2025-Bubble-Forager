extends Node3D

signal fired(bullet)

var start_process = false
var owning_player = null
var weapon_id = 'GUN_BUBBLE'
# ....
var bullet_scn = preload('res://weapons/bubble_bullet.tscn')
var bullet_plat_scn = preload('res://entity/BubblePlatform.tscn')
@onready var bullet_pivot = $BulletPivot


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _exit_tree():
	owning_player = null


func _input(event):
	if start_process:
		var player_device = InputHandler.get_player_device(owning_player.player_id)
		#print('SH %s // %s // %s // %s' % [owning_player, player_device, event.device, event.is_action('rtrigger')])
		if owning_player != null and player_device != null and event.device == player_device:
			var pcam = owning_player.player_cam
			if event.is_pressed() and event.is_action('rtrigger'):
				#print('Shoot')
				var bullet = bullet_scn.instantiate()
				bullet.start_process = true
				bullet.owning_player = owning_player
				fired.emit(bullet)
				bullet.global_basis = pcam.global_basis
				bullet.global_position = pcam.global_position + pcam.global_basis.z.rotated(pcam.global_basis.y.normalized(), PI) * 3
				bullet.velocity =  pcam.global_basis.z.rotated(pcam.global_basis.y.normalized(), PI) * bullet.MAX_SPEED
			if event.is_pressed() and event.is_action('ltrigger'):
				#print('Shoot')
				var bullet = bullet_plat_scn.instantiate()
				fired.emit(bullet)
				bullet.global_position = pcam.global_position + pcam.global_basis.z.rotated(pcam.global_basis.y.normalized(), PI) * 3.5


func _on_death_timer_timeout():
	if start_process:
		call_deferred('queue_free')
