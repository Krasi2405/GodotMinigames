tool
extends EditorPlugin


class_name TilesetPlugin

var dock = preload("res://addons/CustomTileset/TilesetDock.tscn")
var dock_instance : TilesetDock
var tileset : ObjectTileset

func _enter_tree():
	add_custom_type(
			"ObjectTileset", 
			"Node2D",
			preload("ObjectTileset.gd"), 
			preload("tilemap_icon.png")
	)


func edit(object : Object):
	tileset = object as ObjectTileset


func handles(obj : Object):
	return obj is ObjectTileset


func forward_canvas_draw_over_viewport(overlay : Control):
	if not tileset or not tileset.is_inside_tree():
		return

func forward_input_event(event):
	print("Forward input")
	print(event)


func make_visible(visible) -> void:
	print("make_visible(", visible, ")")
	if visible:
		dock_instance = dock.instance() as TilesetDock
		get_editor_interface().get_editor_viewport().add_child(dock_instance)
		dock_instance.set_tiles(tileset.get_objects())
		if dock_instance.has_method("set_tiles"):
			print("has tiles method")
		else:
			print("not has tiles method")
		# dock_instance.set_tiles(tileset.get_objects())
	else:
		if dock_instance:
			dock_instance.queue_free()


func get_plugin_name():
	return "Tileset Plugin"


func _exit_tree():
	if dock_instance:
		dock_instance.queue_free()
	remove_custom_type("ObjectTileset")