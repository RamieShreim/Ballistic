extends Node2D

var code_typing: bool = false
var chars: float = 0

var wallfade: int = -1
var blockfade: int = -1
var centerfade: int = 1

var wallpos: Vector2 = Vector2(0, 0)
var blockpos: Vector2 = Vector2(0, 0)

const bullet = preload("res://Instances/Bullet.tscn")

onready var code = $Code
onready var wall = $Wall
onready var block = $Block
onready var center = $Center

onready var wallout = $WallOutline
onready var blockout = $BlockOutline
onready var centerout = $CenterOutline


func _ready():
	randomize()
	$Block.hide()
	$Wall.hide()
	wallout.modulate.a = 0
	blockout.modulate.a = 0
	
	$TimerEvents.set_wait_time(rand_range(5, 10))


func _process(delta):
	if code_typing:
		code.modulate.a = 1
		chars += 6 * delta
		code.set_visible_characters(round(chars))
	else:
		code.modulate.a = max(code.modulate.a - 3 * delta, 0)
	
	wallout.modulate.a = clamp(wallout.modulate.a + (1 * delta * wallfade), 0, 1)
	blockout.modulate.a = clamp(blockout.modulate.a + (1 * delta * blockfade), 0, 1)
	centerout.modulate.a = clamp(centerout.modulate.a + (1 * delta * centerfade), 0, 1)

func spawn_bullet():
	var bullet_i = bullet.instance()
	if randf() < 0.5:
		bullet_i.dir = 1
		bullet_i.position.x = -10
	else:
		bullet_i.dir = -1
		bullet_i.position.x = 1310
	
	bullet_i.position.y = rand_range(350, 500)
	bullet_i.speed = rand_range(120, 240)
	
	get_tree().get_root().add_child(bullet_i)


func _on_TimerEvents_timeout():
	match int(rand_range(0, 5)):
		0: # Wall
			chars = 0
			code.set_visible_characters(0)
			code.set_text("#define WALL")
			wallpos = Vector2(rand_range(270, 1000), 334)
			wallout.set_position(wallpos)
			wallfade = 1
			$TimerWall.start()
		1: # Bullets
			chars = 0
			code.set_visible_characters(0)
			code.set_text("#define BULLET_1\n#define BULLET_2\n#define BULLET_3")
			$TimerBullet1.start()
			$TimerBullet2.start()
			$TimerBullet3.start()
		2: # Block
			chars = 0
			code.set_visible_characters(0)
			code.set_text("#define BLOCK")
			blockpos = Vector2(rand_range(224, 1066), rand_range(240, 400))
			blockout.set_position(blockpos)
			blockfade = 1
			$TimerBlock.start()
		3: # Remove center
			chars = 0
			code.set_visible_characters(0)
			code.set_text("#undef CENTER")
			$TimerCenter.start()
		4: # Comment
			chars = 0
			code.set_visible_characters(0)
			code.set_text("#warning \"You're starting to bore me.\"")
			$TimerComment.start()
	
	code_typing = true


func _on_TimerWall_timeout():
	$Wall.set_position(wallpos)
	$Wall.show()
	$Wall/CollisionShape2D.set_disabled(false)
	$TimerFadeCode.set_wait_time(rand_range(3.0, 8.0))
	$TimerFadeCode.start()


func _on_TimerBlock_timeout():
	$Block.set_position(blockpos)
	$Block.show()
	$Block/CollisionShape2D.set_disabled(false)
	$TimerFadeCode.set_wait_time(rand_range(3.0, 8.0))
	$TimerFadeCode.start()


func _on_TimerCenter_timeout():
	$Center.hide()
	$Center/CollisionShape2D.set_disabled(true)
	centerfade = -1
	$TimerFadeCode.set_wait_time(rand_range(3.0, 8.0))
	$TimerFadeCode.start()


# I AM SO SORRY
func _on_TimerBullet1_timeout():
	spawn_bullet()


func _on_TimerBullet2_timeout():
	spawn_bullet()


func _on_TimerBullet3_timeout():
	spawn_bullet()
	$TimerFadeCode.set_wait_time(rand_range(3.0, 8.0))
	$TimerFadeCode.start()


func _on_TimerComment_timeout():
	$TimerFadeCode.set_wait_time(rand_range(3.0, 8.0))
	$TimerFadeCode.start()


func _on_TimerFadeCode_timeout():
	$Wall.hide()
	$Wall/CollisionShape2D.set_disabled(true)
	
	$Block.hide()
	$Block/CollisionShape2D.set_disabled(true)
	
	$Center.show()
	$Center/CollisionShape2D.set_disabled(false)
	
	wallfade = -1
	blockfade = -1
	centerfade = 1
	
	code_typing = false
	$TimerEvents.set_wait_time(rand_range(5, 10))
	$TimerEvents.start()
