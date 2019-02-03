extends RigidBody2D

enum {U, D, L, R, UL, UR, DL, DR}
var dir: int = D

var dash_cd: bool = false
var dash_cd_value: float = 100
var cd_bar_hue_init: int

const DASH_SPEED: int = 60000

const parts_dash = preload("res://Instances/Particles/PartsDash.tscn")

onready var cd_bar = $DashCD

func _ready():
	cd_bar_hue_init = cd_bar.tint_progress.h


func _process(delta):
	dash_cd_value = max(dash_cd_value - 1.7 * delta * 60, 0)
	cd_bar.set_value(dash_cd_value)
	cd_bar.tint_progress.h = max(cd_bar.tint_progress.h - 0.21 * delta, 0)
	
	if Input.is_action_pressed("ui_up"):
		dir = U
	elif Input.is_action_pressed("ui_down"):
		dir = D
	elif Input.is_action_pressed("ui_left"):
		apply_impulse(get_position(), Vector2(-500 * delta, 0))
		dir = L
	elif Input.is_action_pressed("ui_right"):
		apply_impulse(get_position(), Vector2(500 * delta, 0))
		dir = R
		
	if Input.is_action_just_pressed("ui_accept") and not dash_cd:
		dash(delta)


func dash(delta):
	var parts = parts_dash.instance()
	parts.set_position(get_position())
	parts.set_emitting(true)
	get_tree().get_root().add_child(parts)
	set_linear_velocity(Vector2(0, 0))
	match dir:
		U:
			apply_impulse(get_position(), Vector2(0, -DASH_SPEED * delta))
		D:
			apply_impulse(get_position(), Vector2(0, DASH_SPEED * delta))
		L:
			apply_impulse(get_position(), Vector2(-DASH_SPEED * delta, 0))
		R:
			apply_impulse(get_position(), Vector2(DASH_SPEED * delta, 0))
	dash_cd = true
	dash_cd_value = 100
	cd_bar.tint_progress = Color(0.4, 1, 0)
	cd_bar.show()
	$TimerDash.start()


func _on_TimerDash_timeout():
	cd_bar.hide()
	dash_cd = false
