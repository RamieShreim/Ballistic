extends KinematicBody2D

var speed: float = 20
var dir: int = 1

func _ready():
	scale *= 5


func _process(delta):
	position.x += speed * dir * delta
	rotation_degrees += (speed * delta)
	
	if get_position().x < -10 or get_position().x > 1500:
		queue_free()
