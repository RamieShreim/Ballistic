extends Control

var damage_1: int = 0
var damage_1_prev: int = 0
var damage_2: int = 0
var damage_2_prev: int = 0

onready var player_1 = get_tree().get_root().get_node("Scene").get_node("Player1")
onready var player_2 = get_tree().get_root().get_node("Scene").get_node("Player2")

onready var label_1 = $PlayerOneControl/Percentage
onready var label_2 = $PlayerTwoControl/Percentage

func _ready():
	pass # Replace with function body.


func _process(delta):
	damage_1 = player_1.damage
	if damage_1 != damage_1_prev:
		damage_1_prev = damage_1
		#label_1.
	label_1.set_text("%d%%" % player_1.damage)
	label_2.set_text("%d%%" % player_2.damage)
	
	#label_1.set_self_modulate(Color(1 - (player_1.damage / 255), 1 - (player_1.damage / 128), 1 - (player_1.damage / 128)))