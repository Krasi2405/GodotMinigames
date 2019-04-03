extends TextureButton

class_name LevelChoice


var _levelPath : String

func _on_TextureButton_button_down():
	get_tree().change_scene(_levelPath)
	
	
func set_level(level : String):
	_levelPath = level


func set_icon(icon_path: String):
	texture_normal = load(icon_path) as Texture
	
