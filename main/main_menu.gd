extends Control

signal request_scene(scene_id, args)


# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/SinglePlayerBtn.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_single_player_btn_pressed():
	request_scene.emit('GAME', 1)


func _on_two_player_btn_pressed():
	request_scene.emit('GAME', 2)


func _input(event):
	if event.is_action('ui_accept'):
		print('Mainmenu accept')
		get_viewport().gui_get_focus_owner().pressed.emit()
