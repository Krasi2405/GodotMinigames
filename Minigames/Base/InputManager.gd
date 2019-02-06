extends Node2D

var button_count

var button_states_pressed_down = []


func _enter_tree():
	Global.InputManager = self

func _ready():
	button_count = Global.MinigameManager.get_player_count()
	
	if button_count <= 3:
		$GameCamera/GUI/Button4.queue_free()
	
	if button_count <= 2:
		$GameCamera/GUI/Button3.queue_free()
	
	if button_count <= 1:
		print("Minigame devloper is idjot!")
		queue_free()
	
	for i in range (0, button_count):
		button_states_pressed_down.append(false)


func is_button_pressed_down(button_id):
	if button_id >= button_count:
		print("Button with id %s does not exist!" % button_id)
		return false
	return button_states_pressed_down[button_id]


func reset_pressed_down_state(button_id):
	if button_id >= button_count:
		print("Button with id %s does not exist!" % button_id)
		return
	
	button_states_pressed_down[button_id] = false


func _on_Button1_button_down():
	button_states_pressed_down[0] = true


func _on_Button2_button_down():
	button_states_pressed_down[1] = true


func _on_Button3_button_down():
	button_states_pressed_down[2] = true


func _on_Button4_button_down():
	button_states_pressed_down[3] = true
