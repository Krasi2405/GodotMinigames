tool
extends EditorPlugin


class_name TilesetPlugin

var dock = preload("res://addons/CustomTileset/TilesetDock.tscn")
var dock_instance : TilesetDock
var tileset : ObjectTileset

var last_scale : float = 1
var last_offset : Vector2 = Vector2(0, 0)

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
	
	var offset : Vector2 = tileset.get_viewport_transform().get_origin()
	# Assume that vector scale x and y will always be equal
	var scale : float = tileset.get_viewport_transform().get_scale().x
	
	draw_grid(overlay, offset, scale)


func forward_canvas_gui_input(event : InputEvent) -> bool:
	
	#if event is InputEventMouse:
		#var viewport_transform_invert := tileset.get_viewport_transform().affine_inverse()
		#var mouse_position = viewport_transform_invert.xform(event.position)
		# print("Update position to ", viewport_position)


	return false

func draw_grid(overlay : Control, offset : Vector2, scale : float):
	
	var grid_size : float = tileset.grid_size * scale
	
	var visible_size := tileset.get_viewport().get_visible_rect().size / scale
	
	var grid_offset = offset
	grid_offset.x = fmod(offset.x, grid_size)
	grid_offset.y = fmod(offset.y, grid_size)
	
	var x_grid_size := (visible_size.x / grid_size * scale) + 1
	var y_grid_size := (visible_size.y / grid_size * scale) + 1
	for x in range(-1, x_grid_size):
		for y in range(-1, y_grid_size):
			draw_square(overlay, grid_offset + Vector2(x * grid_size, y * grid_size), grid_size)


func draw_square(overlay : Control, position : Vector2, grid_size: float) -> void:
	
	var points := PoolVector2Array([
		Vector2(0, 0),
		Vector2(grid_size, 0),
		Vector2(grid_size, grid_size),
		#Vector2(grid_size, 0),
		#Vector2(0, 0)
	])
	
	for i in range(points.size() - 1):
		overlay.draw_line(
			position + points[i], 
			position + points[i + 1], 
			Color(1, 0, 0, 0.4), # transparent red
			1
		)

	"""
	Very optimized way. Looks really bad.
	
	var points := PoolVector2Array([
		position + Vector2(0, 0),
		position + Vector2(grid_size, 0),
		position + Vector2(grid_size, grid_size),
		position + Vector2(0, grid_size),
		position + Vector2(0, 0)
	])
	
	overlay.draw_polyline(points, Color.red, 2) 
	"""


func forward_input_event(event):
	print("Forward input")
	print(event)


func make_visible(visible) -> void:
	print("make_visible(", visible, ")")
	if visible:
		dock_instance = dock.instance() as TilesetDock
		get_editor_interface().get_editor_viewport().add_child(dock_instance)
		dock_instance.set_tiles(tileset.get_objects())
	else:
		for child in get_editor_interface().get_editor_viewport().get_children():
			if child is TilesetDock:
				get_editor_interface().get_editor_viewport().remove_child(child)

		if dock_instance:
			dock_instance.queue_free()


func get_plugin_name():
	return "Tileset Plugin"


func _exit_tree():
	if dock_instance:
		dock_instance.queue_free()
	remove_custom_type("ObjectTileset")