extends Player

var direction = Vector2(0,1)
onready var synchronization_component := (
	$Node2DSynchronizationComponent as Node2DSynchronizationComponent
)

export var speed = 500

master func press_action():
	direction *= -1

func hold_action(delta):
    pass
		
func release_action():
    pass


master func _process(delta):
	var collision : KinematicCollision2D = move_and_collide(direction * speed * delta)
	if(collision != null and not collision.collider is Ball):
		direction *= -1

	synchronization_component.synchronize_position_unreliable(position)
