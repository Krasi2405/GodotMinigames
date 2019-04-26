extends Control

class_name LobbyUser

signal leave_button_pressed(index)

var id := 0
var is_host := false

func initalize(username : String, color : Color, icon : Texture, is_host : bool) -> void:
	_set_name(username)
	_set_color(color)
	_set_icon(icon)
	self.is_host = is_host


func set_id(id : int) -> void:
	self.id = id


func get_id() -> int:
	return id


func is_initialized() -> bool:
	return id != -1

func _on_LeaveButton_button_down() -> void:
	emit_signal("leave_button_pressed", id)


func set_disconnect_btn_active(is_active : bool) -> void:
	$TextureRect/LeaveButton.set_visible(is_active)


func check_is_host() -> bool:
	return is_host


func _set_name(username : String):
	$Name.text = username


func _set_color(color : Color):
	$Name.modulate = color

	
func _set_icon(texture : Texture):
	$TextureRect.set_texture(texture)