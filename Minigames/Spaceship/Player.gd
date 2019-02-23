extends Node2D


func _ready():
	pass
	
func press_action():
	print("Press %s!" % get_parent().player_id)


func hold_action(delta):
	move_and_slide(Vector2(0, -1) * 5000 * delta)


func release_action():
	print("Release!")