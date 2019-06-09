extends RigidBody2D



class_name Ball

var reset_ball := false
onready var synchronization_component := (
	$Node2DSynchronizationComponent as Node2DSynchronizationComponent
)

export var velocity := Vector2(300, 0)

func _ready():
	apply_impulse(Vector2.ZERO, velocity)


func _process(delta):
	synchronization_component.synchronize_position_unreliable(position)


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