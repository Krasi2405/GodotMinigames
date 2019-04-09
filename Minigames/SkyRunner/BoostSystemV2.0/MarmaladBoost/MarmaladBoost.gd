extends Node

func _ready():
	pass # Replace with function body.



func apply_effect(player : Player):
	player.connect("press_action" , self, "shoot_marmalad")
	print("MarmaladBoost")


func shoot_marmalad():
	pass