#extends Node

#onready var screen_size = Vector2(Globals.get("display/widthe"), Globals.get("display/height")) 

#onready var Player = get_node("Player")

#func _ready():
#	var canvas_transform = get_viewport().get_canvas_transform()
#	canvas_transform[2] = Player.get_pos() - screen_size / 2