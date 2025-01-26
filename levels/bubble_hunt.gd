extends Node3D

signal request_scene(menu_id, args)

@onready var bullet_pivot = $BulletPivot
@onready var players = [$HBoxContainer/SubViewportContainer/SubViewport/Player1, $HBoxContainer/SubViewportContainer2/SubViewport/Player2]


# Called when the node enters the scene tree for the first time.
func _ready():
	for pindex in range(players.size()):
		var player = players[pindex]
		GameData.initialize_player(player)
		player.start_process = true
		player.fired.connect(handle_bullet_fired)
		player.global_position = $SpawnPoints.get_child(pindex).global_position

	$GameTimer.start()


func set_player_count(value):
	if value == 1:
		players.erase($HBoxContainer/SubViewportContainer2/SubViewport/Player2)
		$HBoxContainer/SubViewportContainer2.queue_free()


func handle_bullet_fired(bullet):
	bullet_pivot.add_child(bullet)


func _on_fall_trigger_body_entered(body):
	if body.is_in_group('player'):
		var player_index = players.find(body)
		print('AAA')
		body.global_position = $SpawnPoints.get_child(player_index).global_position
		body.velocity = Vector3.ZERO
		body.player_cam.global_basis = $SpawnPoints.get_child(player_index).global_basis


func handle_item_captured():
	pass


func _on_goal_body_entered(body):
	print('Goal -> body enter %s  // %s' % [body, body.owning_player])
	if body.is_in_group('scorable'):
		if body.owning_player:
			print('Score item')
			body.owning_player.score += 1
			body.call_deferred('queue_free')


func _on_game_timer_timeout():
	$EndGameBanner.show()
	$EndGameBanner/BannerTimer.start()


func _on_banner_timer_timeout():
	request_scene.emit('MAIN_MENU', null)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	InputHandler.poll_for_devices()
	for player in players:
		player.set_time($GameTimer.time_left)
