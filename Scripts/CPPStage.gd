extends Node2D

var code_typing: bool = false
var chars: float = 0

onready var code = $Code

func _ready():
	randomize()
	$Block.hide()
	$Wall.hide()
	$TimerEvents.set_wait_time(rand_range(5, 10))
	

func _process(delta):
	if code_typing:
		chars += 6 * delta
		code.set_visible_characters(round(chars))


func _on_TimerEvents_timeout():
	match int(rand_range(0, 5)):
		0: # Wall
			$Code.set_text("#define WALL")
			$TimerWall.start()
		1: # Bullets
			$Code.set_text("#define BULLET_1\n#define BULLET_2\n#define BULLET_3")
		2: # Block
			$Code.set_text("#define BLOCK")
			$TimerBlock.start()
		3: # Remove center
			$Code.set_text("#undef CENTER")
			$TimerCenter.start()
		4: # Comment
			match int(rand_range(0, 5)):
				0:
					$Code.set_text("// HELLO THERE!!")
				1:
					$Code.set_text("// This is very exciting.")
				2:
					$Code.set_text("// Bounce! Bounce! Bounce!")
				3:
					$Code.set_text("std::printf(\"%s\", myDisappointment);")
				4:
					$Code.set_text("// You're starting to bore me.")
			
	#$Code.set_text("#define BLOCK")
	
	code_typing = true


func _on_TimerWall_timeout():
	$Wall.set_position(Vector2(rand_range(270, 1000), 334))
	$Wall.show()
	$Wall/CollisionShape2D.set_disabled(false)


func _on_TimerBlock_timeout():
	$Block.set_position(Vector2(rand_range(224, 1066), rand_range(240, 400)))
	$Block.show()
	$Block/CollisionShape2D.set_disabled(false)


func _on_TimerCenter_timeout():
	$Center.hide()
	$Center/CollisionShape2D.set_disabled(true)
