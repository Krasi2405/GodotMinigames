extends TextureButton


export(String, FILE, "*.tscn") var scene : String

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("button_down", self, "go_to_scene")


func go_to_scene():
	if Global.lobby:
		Global.lobby.reset_local_state()
		Global.lobby.queue_free()
		Global.lobby = null

	get_tree().change_scene(scene)
