extends Node2D


var player_id = 0

func _ready():
	assert($Player != null)


func press_action():
	if $Player.has_method("press_action"):
		$Player.press_action()
	else:
		print("Implement press_action() method in script for Player!")


func hold_action(delta):
	if $Player.has_method("hold_action"):
		$Player.hold_action(delta)
	else:
		print("Implement hold_action() method in script for Player!")


func release_action():
	if $Player.has_method("release_action"):
		$Player.release_action()
	else:
		print("Implement release_action() method in script for Player!")


func die():
	get_parent().remove_player(player_id)
	queue_free()
	