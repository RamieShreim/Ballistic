extends Camera2D

export(Array,NodePath) var tracking_list = []

var tracked_objects = []

func _ready():
	for nodepath in tracking_list: 
		tracked_objects.append(get_node(nodepath))

func _physics_process(delta):
	var finalpos = tracked_objects[0].global_position
	var newarray = tracked_objects.duplicate()
	newarray.pop_front()
	for player in newarray:
		finalpos = (finalpos + player.global_position)/2
	global_position = finalpos - Vector2(
		ProjectSettings.get_setting("display/window/size/width") / 2, 
		ProjectSettings.get_setting("display/window/size/height") / 2)

