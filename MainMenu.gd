extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func load_level_picker(player_count : int):
	assert(player_count >= 2 and player_count <= 4)
	var path = "res://LevelPicker/" + str(player_count) + "PLevelPicker.tscn"
	var level_picker = load(path).instance()
	self.add_child(level_picker)
	$Btns.hide()



func _on_2P_button_down():
	load_level_picker(2)


func _on_3P_button_down():
	load_level_picker(3)


func _on_4P_button_down():
	load_level_picker(4)
