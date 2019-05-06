tool

extends Node2D

class_name ObjectTileset

export(Array, PackedScene) var objects

export var grid_size : int = 32

export var y_offset : int = 0

var objects_dict : Dictionary = {}

func _ready():
	print("Custom tileset instantiated!")
	if Engine.is_editor_hint():
		update_objects_dict()
	
	
func get_objects() -> Array:
	return objects
	

func update_objects_dict() -> void:
	objects_dict.clear()
	for child in get_children():
		var child_pos : Vector2 = child.global_position
		var grid_pos := child_pos / grid_size
		grid_pos.x = floor(grid_pos.x)
		grid_pos.y = floor(grid_pos.y)
		objects_dict[grid_pos] = (child as Node2D)
		print("add child at ", child_pos, " to ", grid_pos)


func instantiate(object: PackedScene, grid_position : Vector2, offset_position : Vector2) -> void: 
	var instance := (object.instance() as Node2D)
	instance.global_position = (grid_position * grid_size) + offset_position + Vector2(0, y_offset)
	
	if objects_dict.has(grid_position):
		remove_instance(grid_position)

	print(get_tree().current_scene)
	objects_dict[grid_position] = instance
	add_child(instance)
	instance.set_owner(get_tree().get_edited_scene_root())


func remove_instance(grid_position : Vector2) -> void:
	if objects_dict.has(grid_position):
		var instance : Node2D = objects_dict.get(grid_position)
		print("removed instance: ", instance)
		objects_dict.erase(grid_position)
		remove_child(instance)