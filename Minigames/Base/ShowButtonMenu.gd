extends Area2D

var is_hidden = true
onready var exit_button : TextureButton

func _ready():
	exit_button = get_parent().get_node("ExitButton")
	connect("input_event", self, "_handle_input")
	exit_button.hide()

func _handle_input(viewport : Node, event : InputEvent, id : int):
	if event is InputEventScreenTouch:
		toggle_exit_button_state()


func toggle_exit_button_state():
	if is_hidden:
		exit_button.show()
	else:
		exit_button.hide()
		
	is_hidden = not is_hidden