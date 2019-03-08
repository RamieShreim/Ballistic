extends Control

var player_move: bool = false

onready var ready = $CanvasLayer/Ready
onready var bounce = $CanvasLayer/Bounce

func _ready():
	pass

func _process(delta):
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fade Ready":
		player_move = true
		bounce.show()
		$AnimationPlayer.play("Fade Bounce")
