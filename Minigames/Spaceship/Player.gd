extends Node2D


func _ready():
	pass
	
func press_action():
	print("Press %s!" % get_parent().player_id)


func hold_action(delta):
	print("Hold with delta %s!" % delta)


func release_action():
	print("Release!")