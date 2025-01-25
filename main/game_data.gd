extends Node

var active_players = {}
var unique_id = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func get_unique_id():
	unique_id += 1
	return unique_id


func add_player():
	player_id = get_unique_id()
	InputHandler.add_player(player_id)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
