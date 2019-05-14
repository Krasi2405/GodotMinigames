extends RigidBody2D



class_name Ball

var reset_ball := false

export var velocity := Vector2(300, 0)

func _ready():
	apply_impulse(Vector2.ZERO, velocity)


func reset():
	reset_ball = true


func _integrate_forces(state : Physics2DDirectBodyState):
	if reset_ball:
		var xform = state.get_transform()
		xform.origin = (get_viewport().size / 2)
		state.set_linear_velocity(Vector2(0, 0))
		state.set_transform(xform)
		velocity *= -1
		apply_impulse(Vector2.ZERO, velocity)
		reset_ball = false