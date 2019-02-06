extends Node2D

export var player_id = 0

func _process(delta):
	var button_pressed = Global.InputManager.is_button_pressed_down(player_id)
	if button_pressed:
		Global.InputManager.reset_pressed_down_state(player_id)
		print("Button for player %s is pressed" % player_id)
	
