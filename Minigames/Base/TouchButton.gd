extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

signal on_button_press()
signal on_button_release()

const BUTTON_SPRITE := "res://Minigames/Base/button.png"
const BUTTON_PRESSED_SPRITE := "res://Minigames/Base/button_pressed.png"

var _pressed_button_sprite : Resource
var _normal_button_sprite : Resource


func _enter_tree():
	_pressed_button_sprite = load(BUTTON_PRESSED_SPRITE)
	_normal_button_sprite = load(BUTTON_SPRITE)
	


func _on_TouchButton_input_event(viewport : Viewport, event : InputEvent, shape_idx : int):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.is_pressed():
			($Sprite as Sprite).texture = _pressed_button_sprite
			emit_signal("on_button_press")
		else:
			($Sprite as Sprite).texture = _normal_button_sprite
			emit_signal("on_button_release")

