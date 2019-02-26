extends Node2D

var player_controller

func _ready():
	player_controller = get_parent()


func press_action():
	print("Press %s!" % get_player_id())


func hold_action(delta):
	print("Hold!")


func release_action():
	
	print("Release!")


func get_player_id():
	return player_controller.player_id