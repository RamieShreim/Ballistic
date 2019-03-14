extends Control

func _process(delta):
	if get_tree().get_current_scene().get_name() == "Credits":
		if Input.is_action_just_pressed("menu_back") or Input.is_action_just_pressed("ui_accept"):
			get_tree().change_scene("res://Scenes/TitleScreen.tscn")
	elif Input.is_action_just_pressed("menu_back"):
		get_tree().change_scene("res://Scenes/TitleScreen.tscn")
