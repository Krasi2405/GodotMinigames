extends KinematicBody2D

export var speed = 10000

var direction = Vector2(0, 0)

func _enter_tree():
	$CollisionShape2D.disabled = true


func _ready():
	$ActivateCollisionTimer.start()
	print("asteroid position", position)


func _process(delta):
	var collision = move_and_collide(direction * speed * delta)
	if(collision != null):
		var object = collision.collider
		print("asteroid collided with ", object.name)
		if(object.has_method("hit")):
			object.hit()
		hit()

func _on_ActivateCollisionTimer_timeout():
	$CollisionShape2D.disabled = false
	

func set_direction(direction):
	self.direction = direction


func hit():
	queue_free()