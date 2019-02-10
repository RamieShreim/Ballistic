extends RigidBody2D

export(bool) var player_two = false
var temp_add: String = ""

var control: bool = true
var dead: bool = false

enum {U, D, L, R, UL, UR, DL, DR}
var dir: int = D

var damage: int = 0

var dash_cd: bool = false
var dash_cd_value: float = 100
var cd_bar_hue_init: int

const DASH_SPEED: int = 32000

const parts_dash = preload("res://Instances/Particles/PartsDash.tscn")

onready var spr = $Sprite
onready var cd_bar = $DashCD
onready var camera = get_tree().get_root().get_node("Scene").get_node("Camera2D")


func _ready():
	cd_bar_hue_init = cd_bar.tint_progress.h
	temp_add = "2" if player_two else ""


func _process(delta):
	# Handle dash meter
	dash_cd_value = max(dash_cd_value - 1.7 * delta * 60, 0)
	cd_bar.set_value(dash_cd_value)
	cd_bar.tint_progress.h = max(cd_bar.tint_progress.h - 0.28 * delta, 0)
	
	if get_position().x < camera.limit_left or get_position().x > camera.limit_right or get_position().y < camera.limit_top or get_position().y > camera.limit_bottom and not dead:
		linear_velocity = Vector2.ZERO
		dead = true
		control = false
		$Sprite.modulate.a = 0
		if get_position().x < camera.limit_left:
			$PartsDie.set_rotation_degrees(0)
		elif get_position().x > camera.limit_right:
			$PartsDie.set_rotation_degrees(180)
		elif get_position().y < camera.limit_top:
			$PartsDie.set_rotation_degrees(90)
		elif get_position().y > camera.limit_bottom:
			$PartsDie.set_rotation_degrees(270)
		$PartsDie.set_emitting(true)
		$TimerRespawn.start()


func _physics_process(delta):
	# Bounce animation
	if len(get_colliding_bodies()) > 0:
		spr.set_scale(Vector2(1, 0.5))
		
	spr.scale.y = min(spr.scale.y + 1 * delta, 1)
	
	if control:
		input(delta)
	
	if dead:
		linear_velocity = Vector2.ZERO


func input(delta):
	if Input.is_action_pressed("ui_up" + temp_add):
		if Input.is_action_pressed("ui_left" + temp_add):
			dir = UL
		elif Input.is_action_pressed("ui_right" + temp_add):
			dir = UR
		else:
			dir = U
	elif Input.is_action_pressed("ui_down" + temp_add):
		if Input.is_action_pressed("ui_left" + temp_add):
			dir = DL
		elif Input.is_action_pressed("ui_right" + temp_add):
			dir = DR
		else:
			dir = D
	elif Input.is_action_pressed("ui_left" + temp_add):
		apply_impulse(get_position(), Vector2(-500 * delta, 0))
		if Input.is_action_pressed("ui_up" + temp_add):
			dir = UL
		elif Input.is_action_pressed("ui_down" + temp_add):
			dir = DL
		else:
			dir = L
	elif Input.is_action_pressed("ui_right" + temp_add):
		apply_impulse(get_position(), Vector2(500 * delta, 0))
		if Input.is_action_pressed("ui_up" + temp_add):
			dir = UR
		elif Input.is_action_pressed("ui_down" + temp_add):
			dir = DR
		else:
			dir = R
		
	if Input.is_action_just_pressed("ui_accept" + temp_add) and not dash_cd:
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
		UL:
			apply_impulse(get_position(), Vector2(-DASH_SPEED * delta, -DASH_SPEED * delta) / 1.25)
		UR:
			apply_impulse(get_position(), Vector2(DASH_SPEED * delta, -DASH_SPEED * delta) / 1.25)
		DL:
			apply_impulse(get_position(), Vector2(-DASH_SPEED * delta, DASH_SPEED * delta) / 1.25)
		DR:
			apply_impulse(get_position(), Vector2(DASH_SPEED * delta, DASH_SPEED * delta) / 1.25)
			
	dash_cd = true
	dash_cd_value = 100
	cd_bar.tint_progress = Color(0.4, 1, 0)
	cd_bar.show()
	$TimerDash.start()


func _on_TimerDash_timeout():
	cd_bar.hide()
	dash_cd = false


func _on_Player_body_entered(body):
	if dash_cd and body.is_in_group("Player"):
		if linear_velocity > body.linear_velocity:
			body.damage += 10
		elif linear_velocity < body.linear_velocity:
			damage += 10


func _on_TimerRespawn_timeout():
	set_position(Vector2(520, 100))
	$Sprite.modulate.a = 1
	damage = 0
	dead = false
	control = true
