extends RigidBody2D



class_name Ball


func _ready():
	var velocity := Vector2(300, 0)
	apply_impulse(Vector2.ZERO, velocity)