extends TextureButton

tool
class_name LevelChoice

signal chosen(level)


export var _levelPath : String setget set_level

func _on_TextureButton_button_down():
	emit_signal("chosen", _levelPath)
	
	
func set_level(level : String):
	_levelPath = level


func set_icon(icon_path: String):
	texture_normal = load(icon_path) as Texture
	
