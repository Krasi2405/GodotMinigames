extends TouchScreenButton


var start_global : Vector2

var objects_under_button_count = 0

func _ready():
	start_global = $Area2D.global_position
	
	
func _process(delta):
	$Area2D.global_position = start_global + get_viewport().canvas_transform.get_origin()


func _on_Area2D_body_entered(body : PhysicsBody2D):
	if body == null:
		return
	# print("Entered ", body.name)
	objects_under_button_count += 1
	modulate.a = 0.5
	

func _on_Area2D_body_exited(body : PhysicsBody2D):
	if body == null:
		return
	# print("Exited ", body.name)
	objects_under_button_count -= 1
	if objects_under_button_count <= 0:
		modulate.a = 1