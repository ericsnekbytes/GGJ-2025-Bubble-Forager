extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	for player in [$Player1]:
		GameData.initialize_player(player)
		player.start_process = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	InputHandler.poll_for_devices()
