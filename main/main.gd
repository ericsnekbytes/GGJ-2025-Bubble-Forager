extends Node

var scenes = {
	'MAIN_MENU': preload("res://main/main_menu.tscn"),
	'GAME': preload("res://levels/bubble_hunt.tscn"),
}


# Called when the node enters the scene tree for the first time.
func _ready():
	load_scene('MAIN_MENU', null)


func load_scene(scene_id, args):
	if scene_id in scenes:
		print('LOAD SCN %s' % scene_id)
		if get_child_count() > 0:
			get_child(0).queue_free()
		var new_scene = scenes[scene_id].instantiate()
		new_scene.request_scene.connect(load_scene)
		add_child(new_scene)
		if args != null:
			new_scene.set_player_count(args)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
