extends Node

class_name LocalUser

var is_host := false
var id := -1


func _ready():
	pass # Replace with function body.


func set_id(id : int) -> void:
	self.id = id

func get_id() -> int:
	return id

func is_initialized() -> bool:
	return id != -1


func check_is_host() -> bool:
	return is_host