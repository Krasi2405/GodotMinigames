extends  KinematicBody2D

var logRotate = true

export var rotationSpeed = 0.06
export var movmentSpeed = 5000


func _ready():
	pass
	
func press_action():
	logRotate = false
	print("Press %s!" % get_parent().player_id)
	
func hold_action(delta):
	logRotate = false;
	move_and_slide(-get_global_transform().y.normalized() * movmentSpeed * delta)

func release_action():
	logRotate = true
	print("Release!")

func _process(delta):
	if logRotate:
		rotation = self.rotation + deg2rad(90 * rotationSpeed)
