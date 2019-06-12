"""
Register mouse input event and change it to mobile input event
so that game can be used in editor.
"""

extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _enter_tree():
	if OS.get_name() != "Windows":
		disconnect("gui_input", self, "_on_GUI_gui_input")


func _on_GUI_gui_input(event : InputEvent):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		var mobile_event : InputEventScreenTouch = InputEventScreenTouch.new()
		mobile_event.position = event.position
		mobile_event.pressed = event.pressed
		mobile_event.index = 1
		get_tree().input_event(mobile_event)
