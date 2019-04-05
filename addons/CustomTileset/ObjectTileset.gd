tool

extends Node2D

class_name ObjectTileset

export(Array, PackedScene) var objects

export var grid_size : int = 32

func _ready():
	if not Engine.is_editor_hint():
		queue_free()
	print("Custom tileset!")
	
	
func get_objects():
	return objects
