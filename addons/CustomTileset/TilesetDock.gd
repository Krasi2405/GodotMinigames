tool

extends Control

class_name TilesetDock

var item_prefab = preload("res://addons/CustomTileset/TileItem.tscn")

	
func set_tiles(tiles : Array) -> void:
	var container = $PanelContainer/VBoxContainer
	for node in container.get_children():
		container.remove_child(node)
		node.queue_free()
	
	for tile in tiles:
		tile = (tile as PackedScene)
		var item_instance := item_prefab.instance() as TileItem
		item_instance.set_object(tile)
		container.add_child(item_instance)
