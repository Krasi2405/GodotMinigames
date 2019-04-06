tool

extends Button

class_name TileItem

export var test_path : String

var object : PackedScene

var instance : Node

var parent

signal selected(selected_object, selected_image)

func _ready():
	"""
	var image := get_object_representation_by_first_sprite(load(test_path))
	object = load(test_path)
	var texture := ImageTexture.new()
	texture.create_from_image(image)
	_set_image(texture)
	"""
	
	"""
	instance = (load(test_path).instance(0) as Node)
	instance.position = $Image.rect_global_position + ($Image.rect_size / 2)
	instance.set_script(null)
	add_child(instance)
	"""
	pass


func _on_TileItem_pressed():
	emit_signal("selected", self.object, _get_object_representation_by_first_sprite(self.object))


func set_object(object : PackedScene) -> void:
	self.object = object
	_set_image_by_first_object_sprite(object)
	_set_name(object.instance().name)


func set_parent(parent) -> void:
	self.parent = parent

func get_image() -> Image:
	return _get_object_representation_by_first_sprite(self.object)

func get_object() -> PackedScene:
	return self.object


func _set_image_by_first_object_sprite(object : PackedScene) -> void:
	var sprite := _get_object_representation_by_first_sprite(object)
	var texture := ImageTexture.new()
	texture.create_from_image(sprite)
	_set_image(texture)


func _set_image_by_mapping_object_sprites(object : PackedScene) -> void:
	var sprite := _get_object_representation_by_mapping(object)
	var texture := ImageTexture.new()
	texture.create_from_image(sprite)
	_set_image(texture)


func _set_image(image : Texture) -> void:
	($Image as TextureRect).texture = image


func _set_name(item_name : String) -> void:
	($Name as RichTextLabel).text = item_name



func _get_object_representation_by_first_sprite(object : PackedScene) -> Image:
	
	var loaded := (object.instance() as Node2D)
	var image := Image.new()
	if loaded is Sprite:
		var sprite := loaded as Sprite
		return sprite.texture.get_data()

	return _get_first_object_sprite(loaded)


func _get_first_object_sprite(object : Node2D) -> Image:
	for child in object.get_children():
		if child is Sprite:
			var sprite := child as Sprite
			return sprite.texture.get_data()

		var child_node := child as Node2D
		var child_sprite := _get_first_object_sprite(child_node)
		if child_sprite != null:
			return child_sprite
		
	return null



func _get_object_representation_by_mapping(object : PackedScene) -> Image:
	var loaded := (object.instance() as Node2D)
	var image := Image.new()
	image.create(8, 8, false, 5)
	print(image)
	return _get_object_sprite_recursion(loaded, image)



func _get_object_sprite_recursion(object : Node2D, image : Image) -> Image:
	if object.get_child_count() <= 0:
		return image

	print("Running on ", object.name)

	for child in object.get_children():
		var child_node := child as Node2D
		if child_node == null:
			print(child.name, " is not node2d")
			continue

		print(child_node.name)
		if child_node is Sprite:
			print("Is sprite")
			var sprite := (child_node as Sprite)
			var texture_image : Image = sprite.texture.get_data()
			texture_image.lock()
			image.lock()
			
			if image.get_width() < texture_image.get_width():
				image.crop(texture_image.get_width(), image.get_height())

			if image.get_height() < texture_image.get_height():
				image.crop(image.get_width(), texture_image.get_height())
			
			for x in texture_image.get_width():
				for y in texture_image.get_height():
					image.set_pixel(x, y, texture_image.get_pixel(x, y))
			image.unlock()
			texture_image.unlock()
		
		image = _get_object_sprite_recursion(child_node, image)
		
	return image
