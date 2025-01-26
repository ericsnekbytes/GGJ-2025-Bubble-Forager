extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	for player in [$Player1]:
		GameData.initialize_player(player)
		player.start_process = true


func _on_fall_trigger_body_entered(body):
	if body.is_in_group('player'):
		print('AAA')
		body.global_position = $Spawn.global_position
		body.velocity = Vector3.ZERO
		body.player_cam.global_basis = $Spawn.global_basis


func handle_item_captured():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	InputHandler.poll_for_devices()
