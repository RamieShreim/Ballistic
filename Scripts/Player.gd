extends RigidBody2D

export(Color) var ball_color = 0xFFFFFFFF
export(bool) var player_two = false
var temp_add: String = ""

var control: bool = true
var dead: bool = false
var resp: bool = false

enum {U, D, L, R, UL, UR, DL, DR}
var dir: int = D
var dash_dir: int = D
const dash_knockback: int = 10
var can_hit: bool = true

var damage: int = 0
var stock: int = 3

var dash_cd: bool = false
var dash_cd_value: float = 100
var cd_bar_hue_init: int
var can_dash: bool = true

const DASH_SPEED: int = 32000

const parts_dash = preload("res://Instances/Particles/PartsDash.tscn")
const burst_player = preload("res://Instances/System/SoundBurst.tscn")
const sound_bounce = preload("res://Sounds/Bounce.ogg")
const sound_hit = preload("res://Sounds/hit_effect.wav")
const part_mat_2 = preload("res://Instances/Particles/Player2Death.tres")

onready var spr = $Sprite
onready var cd_bar = $DashCD
onready var arrow = $Arrow
onready var camera = get_tree().get_root().get_node("Scene").get_node("Camera2D")


func _ready():
	arrow.hide()
	cd_bar_hue_init = cd_bar.tint_progress.h
	temp_add = "2" if player_two else "" # I am so sorry
	spr.set_self_modulate(ball_color)
	arrow.set_self_modulate(ball_color)
	$PartsDie.set_process_material($PartsDie.get_process_material().duplicate())
	$PartsDie.get_process_material().set_color(ball_color)


func _process(delta):
	# Handle dash meter
	dash_cd_value = max(dash_cd_value - 1.7 * delta * 60, 0)
	cd_bar.set_value(dash_cd_value)
	cd_bar.tint_progress.h = max(cd_bar.tint_progress.h - 0.28 * delta, 0)
	
	# Respawn suspend
	if resp:
		linear_velocity = Vector2.ZERO
		
	# Control arrow
	match dir:
		U:
			arrow.set_rotation_degrees(0)
		UR:
			arrow.set_rotation_degrees(45)
		R:
			arrow.set_rotation_degrees(90)
		DR:
			arrow.set_rotation_degrees(135)
		D:
			arrow.set_rotation_degrees(180)
		DL:
			arrow.set_rotation_degrees(225)
		L:
			arrow.set_rotation_degrees(270)
		UL:
			arrow.set_rotation_degrees(315)


func _physics_process(delta):
	# Bounce animation
	if len(get_colliding_bodies()) > 0:
		var sound = burst_player.instance()
		sound.set_stream(sound_bounce)
		sound.set_volume_db(-12)
		get_tree().get_root().add_child(sound)
		spr.set_scale(Vector2(1, 0.5))
		can_dash = true
		
	spr.scale.y = min(spr.scale.y + 1 * delta, 1)
	
	if control and MatchStart.player_move:
		input(delta)
	
	if dead:
		linear_velocity = Vector2.ZERO
	
	if (get_position().x < camera.limit_left or get_position().x > camera.limit_right or get_position().y < camera.limit_top or get_position().y > camera.limit_bottom) and not dead:
		$SoundDie.play()
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
		$CollisionShape2D.set_disabled(true)
		stock -= 1
		if stock > 0:
			$TimerRespawn.start()
		else:
			if not MatchStart.match_over:
				MatchStart.winner = 1 if temp_add == "" else 0
				MatchStart.match_over = true
			$TimerRestart.start()


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
		
	if Input.is_action_just_pressed("ui_accept" + temp_add) and not dash_cd:# and can_dash:
		dash_dir = dir
		dash(delta)
		can_dash = false


func dash(delta):
	$SoundDash.play()
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
	if resp:
		$CollisionShape2D.set_disabled(false)
		arrow.hide()
		resp = false
		$TimerRespawnHB.stop()


func _on_TimerDash_timeout():
	cd_bar.hide()
	dash_cd = false


func _on_Player_body_entered(body):
	if dash_cd and body.is_in_group("Player"):
		if not body.dash_cd:
			body.get_node("PartsHit").set_emitting(true)
			var sound = burst_player.instance()
			sound.set_stream(sound_hit)
			sound.set_volume_db(4)
			get_tree().get_root().add_child(sound)
		else:
			if linear_velocity > body.linear_velocity:
				body.get_node("PartsHit").set_emitting(true)
				var sound = burst_player.instance()
				sound.set_stream(sound_hit)
				sound.set_volume_db(4)
				get_tree().get_root().add_child(sound)
			elif linear_velocity < body.linear_velocity:
				get_node("PartsHit").set_emitting(true)
				var sound = burst_player.instance()
				sound.set_stream(sound_hit)
				sound.set_volume_db(4)
				get_tree().get_root().add_child(sound)


func _on_TimerRespawn_timeout():
	arrow.show()
	set_position(Vector2(600 if player_two else 440, 100))
	$Sprite.modulate.a = 1
	damage = 0
	dead = false
	resp = true
	control = true
	can_dash = true
	$TimerRespawnHB.start()


func _on_TimerRespawnHB_timeout():
	$CollisionShape2D.set_disabled(false)
	resp = false
	arrow.hide()


func _on_TimerRestart_timeout():
	MatchStart.play_winsound()
	get_tree().change_scene("res://Scenes/Ending.tscn")


func _on_TimerHit_timeout():
	can_hit = true



