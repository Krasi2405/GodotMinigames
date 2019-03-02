extends Node2D

var button_count = 4

var button_states_is_held = []

signal on_button_press(button_id)
signal on_button_hold(button_id, delta)
signal on_button_release(button_id)

func _enter_tree():
	Global.InputManager = self

func _ready():
	var minigame_manager = Global.MinigameManager
	
	if minigame_manager:
		button_count = minigame_manager.get_player_count()
	else:
		print("No minigame manager!")
	
	remove_unused_buttons();
	
	if button_count <= 1:
		print("Minigame developer is debil!!!")
		queue_free()
	
	for i in range (0, button_count):
		button_states_is_held.append(false)
		
func remove_unused_buttons():
	if button_count <= 3:
		$GameCamera/GUI/Button4.queue_free()
	
	if button_count <= 2:
		$GameCamera/GUI/Button3.queue_free()
		
func _physics_process(delta):
	for i in range(0, button_count):
		var button_is_held = button_states_is_held[i]
		if button_is_held:
			emit_signal("on_button_hold", i, delta)


func _on_Button1_button_down():
	button_states_is_held[0] = true
	emit_signal("on_button_press", 0)


func _on_Button2_button_down():
	button_states_is_held[1] = true
	emit_signal("on_button_press", 1)


func _on_Button3_button_down():
	button_states_is_held[2] = true
	emit_signal("on_button_press", 2)


func _on_Button4_button_down():
	button_states_is_held[3] = true
	emit_signal("on_button_press", 3)
	

func _on_Button1_button_up():
	button_states_is_held[0] = false
	emit_signal("on_button_release", 0)


func _on_Button2_button_up():
	button_states_is_held[1] = false
	emit_signal("on_button_release", 1)


func _on_Button3_button_up():
	button_states_is_held[2] = false
	emit_signal("on_button_release", 2)


func _on_Button4_button_up():
	button_states_is_held[3] = false
	emit_signal("on_button_release", 3)


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
