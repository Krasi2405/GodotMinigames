extends TextureButton

var level

func _on_TextureButton_button_down():
	get_tree().change_scene(level)
