tool

extends Control

class_name TilesetDock

var item_prefab = preload("res://addons/CustomTileset/TileItem.tscn")


signal selection(selected_object, selected_image)

# TODO: Signal to give selected to plugin

func set_tiles(tiles : Array) -> void:
	var container = $PanelContainer/VBoxContainer
	for node in container.get_children():
		container.remove_child(node)
		node.queue_free()
	
	for tile in tiles:
		tile = (tile as PackedScene)
		var item_instance = item_prefab.instance() as TileItem
		item_instance.set_object(tile)
		item_instance.set_parent(self)
		item_instance.connect("selected", self, "set_selected")
		container.add_child(item_instance)


func set_selected(object : PackedScene, image : Image) -> void:
	emit_signal("selection", object, image)



func set_height(height : float) -> void:
	pass
	
	# $PanelContainer.set_end(end)