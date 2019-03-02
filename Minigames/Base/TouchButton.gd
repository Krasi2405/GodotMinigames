extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

signal on_button_press()
signal on_button_release()

const BUTTON_SPRITE = "res://Minigames/Base/button.png"
const BUTTON_PRESSED_SPRITE = "res://Minigames/Base/button_pressed.png"


func _on_TouchButton_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.is_pressed():
			$Sprite.texture = load(BUTTON_PRESSED_SPRITE)
			emit_signal("on_button_press")
		else:
			$Sprite.texture = load(BUTTON_SPRITE)
			emit_signal("on_button_release")

