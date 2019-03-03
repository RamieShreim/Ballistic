extends Button

export(PackedScene) var scene_to_change_to

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Restart_pressed():
	get_tree().change_scene_to(scene_to_change_to) # Replace with function body.
