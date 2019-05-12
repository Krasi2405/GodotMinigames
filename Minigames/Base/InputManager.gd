"""
Handles button input and sends it to minigame manager.
"""

extends Node2D

class_name InputManager

var player_count := 4

var button_states_is_held : Array = []

signal on_button_press(button_id)
signal on_button_hold(button_id, delta)
signal on_button_release(button_id)

func _enter_tree():
	Global.set_input_manager(self)


func _ready():
	var minigame_manager : MinigameManager = Global.get_minigame_manager()
	
	if minigame_manager:
		player_count = minigame_manager.get_player_count()
	else:
		print("No minigame manager!")
	
	_remove_unused_buttons();
	
	if player_count <= 1:
		print("Minigame developer is debil!!!")
		queue_free()
	
	for i in range (0, player_count):
		button_states_is_held.append(false)


func _remove_unused_buttons():
	if player_count <= 3:
		remove_button(3)
	
	if player_count <= 2:
		remove_button(2)


func remove_button(button_id : int) -> void:
	get_node("GUI/Button" + str(button_id)).queue_free()


func _physics_process(delta):
	for i in range(0, player_count):
		var button_is_held = button_states_is_held[i]
		if button_is_held:
			emit_signal("on_button_hold", i, delta)


func _on_Button1_pressed():
	button_states_is_held[0] = true
	emit_signal("on_button_press", 0)


func _on_Button1_released():
	button_states_is_held[0] = false
	emit_signal("on_button_release", 0)


func _on_Button2_pressed():
	button_states_is_held[1] = true
	emit_signal("on_button_press", 1)


func _on_Button2_released():
	button_states_is_held[1] = false
	emit_signal("on_button_release", 1)


func _on_Button3_pressed():
	button_states_is_held[2] = true
	emit_signal("on_button_press", 2)


func _on_Button3_released():
	button_states_is_held[2] = false
	emit_signal("on_button_release", 2)


func _on_Button4_pressed():
	button_states_is_held[3] = true
	emit_signal("on_button_press", 3)


func _on_Button4_released():
	button_states_is_held[3] = false
	emit_signal("on_button_release", 3)
