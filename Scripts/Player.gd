extends RigidBody2D

var dash_dir: Vector2 = Vector2(1, 1)

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		apply_impulse(get_position(), Vector2(-500 * delta, 0))
		dash_dir = Vector2(-1.2, 1)
	elif Input.is_action_pressed("ui_right"):
		apply_impulse(get_position(), Vector2(500 * delta, 0))
		dash_dir = Vector2(1.2, 1)
	else:
		dash_dir = Vector2(1, 1)
	if Input.is_action_just_pressed("ui_accept"):
		linear_velocity *= dash_dir
