extends Player

var direction = Vector2(0,1)
onready var synchronization_component := (
	$Node2DSynchronizationComponent as Node2DSynchronizationComponent
)

export var speed = 500

master func press_action():
	change_direction()


func hold_action(delta):
    pass
		
func release_action():
    pass


master func _process(delta):
	var collision : KinematicCollision2D = move_and_collide(direction * speed * delta)
	if(collision != null and not collision.collider is Ball):
		change_direction()


func change_direction():
	direction *= -1
	if Global.lobby:
		rpc("synchronize_direction", direction, position)


puppet func synchronize_direction(direction : Vector2, position : Vector2):
	self.direction = direction
	self.position = position