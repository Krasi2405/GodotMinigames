extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _on_GUI_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		var mobile_event = InputEventScreenTouch.new()
		mobile_event.position = event.position
		mobile_event.pressed = event.pressed
		mobile_event.index = 1
		get_tree().input_event(mobile_event)
