extends Control

var player_move: bool = false
var winner: int = -1

onready var ready = $CanvasLayer/Ready
onready var bounce = $CanvasLayer/Bounce
onready var prog = $CanvasLayer/ProgressBar
onready var timer_start = $TimerStart

#func _ready():
#	pass

func _process(delta):
	prog.set_value(timer_start.get_time_left() / 1.45)


func play_winsound():
	match winner:
		0:
			$P1Win.play()
		1:
			$P2Win.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fade Ready":
		player_move = true
		prog.hide()
		bounce.show()
		$AnimationPlayer.play("Fade Bounce")
