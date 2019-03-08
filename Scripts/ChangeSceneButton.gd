extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


export(PackedScene) var scene

const match_start = preload("res://Instances/MatchStart.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func pressed():
	if get_tree().get_current_scene().get_name() == "stage selection":
		#MatchStart.set_position(Vector2(480, 270))
		MatchStart.player_move = false
		MatchStart.get_node("AnimationPlayer").play("Fade Ready")
		MatchStart.get_node("SoundMatchStart").play()
		
	get_tree().change_scene_to(scene)
