extends Control

var damage_1: int = 0
var damage_1_prev: int = 0
var damage_2: int = 0
var damage_2_prev: int = 0

onready var player_1 = get_tree().get_root().get_node("Scene").get_node("Player1")
onready var player_2 = get_tree().get_root().get_node("Scene").get_node("Player2")
	
onready var stock_1_1 = $PlayerOneControl/LifeCounter/TextureRect
onready var stock_1_2 = $PlayerOneControl/LifeCounter/TextureRect2
onready var stock_1_3 = $PlayerOneControl/LifeCounter/TextureRect3

onready var stock_2_1 = $PlayerTwoControl/LifeCounter2/TextureRect
onready var stock_2_2 = $PlayerTwoControl/LifeCounter2/TextureRect2
onready var stock_2_3 = $PlayerTwoControl/LifeCounter2/TextureRect3


func _ready():
	
	pass # Replace with function body.


func _process(delta):
	damage_1 = player_1.damage
	if damage_1 != damage_1_prev:
		damage_1_prev = damage_1
		#label_1.
	
	match player_1.stock: # I am so sorry again
		3:
			stock_1_1.show()
			stock_1_2.show()
			stock_1_3.show()
		2:
			stock_1_1.show()
			stock_1_2.show()
			stock_1_3.hide()
		1:
			stock_1_1.show()
			stock_1_2.hide()
			stock_1_3.hide()
		_:
			stock_1_1.hide()
			stock_1_2.hide()
			stock_1_3.hide()
			
	match player_2.stock:
		3:
			stock_2_1.show()
			stock_2_2.show()
			stock_2_3.show()
		2:
			stock_2_1.show()
			stock_2_2.show()
			stock_2_3.hide()
		1:
			stock_2_1.show()
			stock_2_2.hide()
			stock_2_3.hide()
		_:
			stock_2_1.hide()
			stock_2_2.hide()
			stock_2_3.hide()
	
	#label_1.set_self_modulate(Color(1 - (player_1.damage / 255), 1 - (player_1.damage / 128), 1 - (player_1.damage / 128)))