extends Control

class_name LobbyUser

signal leave_button_pressed(index)

var network_id := -1

func initalize(
	username : String, 
	color : Color,
	icon : Texture) -> void:

	_set_name(username)
	_set_color(color)
	_set_icon(icon)


func _ready():
	set_network_master(get_network_id())


master func set_username():
	var username = OS.get_model_name()
	_set_name(username)
	rpc("set_username_remote", username)


remote func set_username_remote(username : String):
	_set_name(username)


func set_network_id(network_id : int) -> void:
	self.network_id = network_id


func get_network_id() -> int:
	return network_id


func is_initialized() -> bool:
	return network_id != -1


func _on_LeaveButton_button_down() -> void:
	emit_signal("leave_button_pressed", network_id)


func set_disconnect_btn_active(is_active : bool) -> void:
	$TextureRect/LeaveButton.set_visible(is_active)
	

func _set_name(username : String):
	$Name.text = username


func _set_color(color : Color):
	$Name.modulate = color

	
func _set_icon(texture : Texture):
	$TextureRect.set_texture(texture)