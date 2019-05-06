tool
extends EditorPlugin


class_name TilesetPlugin

var dock = preload("res://addons/CustomTileset/TilesetDock.tscn")
var dock_instance : TilesetDock
var tileset : ObjectTileset

var selected_item : PackedScene

var selected_texture : Texture

var selected_placeholder_position : Vector2 = Vector2(0, 0)

func _enter_tree():
	add_custom_type(
			"ObjectTileset", 
			"Node2D",
			preload("ObjectTileset.gd"), 
			preload("tilemap_icon.png")
	)
	
	connect("main_screen_changed", self, "screen_changed")


func edit(object : Object):
	print("edit called!")
	tileset = object as ObjectTileset


func handles(obj : Object):
	return obj is ObjectTileset


func clear() -> void:
	print("clear")


func forward_canvas_draw_over_viewport(overlay : Control):
	
	if not tileset or not tileset.is_inside_tree():
		return
	
	var offset : Vector2 = tileset.get_viewport_transform().get_origin()
	# Assume that vector scale x and y will always be equal
	var scale : float = tileset.get_viewport_transform().get_scale().x
	
	draw_grid(overlay, offset, scale)
	
	if selected_item:
		
		var snapped_location = get_snap_to_grid_position(
			selected_placeholder_position, 
			tileset.grid_size
		)
		overlay.draw_texture_rect(
			selected_texture,
			Rect2(
				snapped_location * scale + offset,
				(selected_texture.get_size() + Vector2(0, tileset.y_offset)) * scale ),
			false
		)
		#
		#overlay.draw_texture(
		#	selected_texture, 
		#	selected_placeholder_position * scale + offset - grid_location
		#)
		
func forward_canvas_force_draw_over_viewport(overlay : Control):
	print("force draw")

func set_input_event_forwarding_always_enabled():
	pass


func screen_changed(node_name : String):
	print("change main screen")
	if dock_instance and tileset:
		if node_name != "2D":
			dock_instance.hide()
		else:
			dock_instance.show()
			


func forward_canvas_gui_input(event : InputEvent) -> bool:
	
	if not tileset or not tileset.is_inside_tree():
		return false

	var event_is_used = false
	
	if event is InputEventMouseButton:
		var mouse_event := (event as InputEventMouseButton)
		
		if mouse_event.is_pressed():
			
			var offset : Vector2 = tileset.get_viewport_transform().get_origin()
			var scale : float = tileset.get_viewport_transform().get_scale().x
			
			var snapped_position = get_snap_to_grid_position(
				mouse_event.position - offset, 
				tileset.grid_size * scale
			)

			var grid_position = snapped_position / tileset.grid_size / scale

			
			var undo := get_undo_redo()
			if mouse_event.get_button_index() == BUTTON_LEFT:
				print("add object")
				event_is_used = true
				tileset.instantiate(selected_item, grid_position, selected_texture.get_size() / 2)
				
			if mouse_event.get_button_index() == BUTTON_RIGHT:
				print("remove object")
				event_is_used = true
				tileset.remove_instance(grid_position)
		
	
	if event is InputEventMouseMotion:
		var motion_event := (event as InputEventMouseMotion)
		var viewport_transform_invert := tileset.get_viewport_transform().affine_inverse()
		var mouse_position = viewport_transform_invert.xform(motion_event.position)
		
		selected_placeholder_position = mouse_position
		
		update_overlays()
		
	return event_is_used


func draw_grid(overlay : Control, offset : Vector2, scale : float):
	
	var grid_size : float = tileset.grid_size * scale
	
	var visible_size := get_editor_interface().get_editor_viewport().rect_size / scale
	
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


func make_visible(visible) -> void:
	print("make_visible(", visible, ")")
	if visible:
		dock_instance = dock.instance() as TilesetDock
		var height = get_editor_interface().get_editor_viewport().rect_size.y
		dock_instance.set_height(height)
		dock_instance.connect("selection", self, "set_selection")
		
		get_editor_interface().get_editor_viewport().add_child(dock_instance)
		dock_instance.set_tiles(tileset.get_objects())
		
		update_overlays()
	else:
		for child in get_editor_interface().get_editor_viewport().get_children():
			if child is TilesetDock:
				get_editor_interface().get_editor_viewport().remove_child(child)

		if dock_instance:
			dock_instance.queue_free()


func get_snap_to_grid_position(position : Vector2, grid_size : float) -> Vector2:
	var grid_location := Vector2(
		fmod(position.x, grid_size), 
		fmod(position.y, grid_size)
	)
	
	if grid_location.x < 0:
		grid_location.x += grid_size
	if grid_location.y < 0:
		grid_location.y += grid_size

	return position - grid_location


func set_selection(object : PackedScene, image : Image) -> void:
	selected_item = object
	
	var texture := ImageTexture.new()
	texture.create_from_image(image)
	selected_texture = texture
	
	update_overlays()


func get_plugin_name():
	return "Tileset Plugin"


func _exit_tree():
	if dock_instance:
		dock_instance.queue_free()
	remove_custom_type("ObjectTileset")
