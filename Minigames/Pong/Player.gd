extends Player

var direction = Vector2(0,1)
export var speed = 500

func press_action():
		direction *= -1
		
func hold_action(delta):
    pass
		
func release_action():
    pass
		
func _process(delta):
	var collision : KinematicCollision2D = move_and_collide(direction * speed * delta)
	if(collision != null and not collision.collider is Ball):
		direction *= -1
