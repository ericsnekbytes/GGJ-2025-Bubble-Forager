extends Node3D

@onready var bullet_pivot = $BulletPivot


# Called when the node enters the scene tree for the first time.
func _ready():
	for player in [$Player1]:
		GameData.initialize_player(player)
		player.start_process = true
		player.fired.connect(handle_bullet_fired)


func handle_bullet_fired(bullet):
	bullet_pivot.add_child(bullet)


func _on_fall_trigger_body_entered(body):
	if body.is_in_group('player'):
		print('AAA')
		body.global_position = $Spawn.global_position
		body.velocity = Vector3.ZERO
		body.player_cam.global_basis = $Spawn.global_basis


func handle_item_captured():
	pass


func _on_goal_body_entered(body):
	print('Goal -> body enter %s  // %s' % [body, body.owning_player])
	if body.is_in_group('scorable'):
		if body.owning_player:
			print('Score item')
			body.owning_player.score += 1
			body.call_deferred('queue_free')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	InputHandler.poll_for_devices()
