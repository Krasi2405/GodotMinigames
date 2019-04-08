extends Area2D


export var speed = 500

var direction
var player

func _ready():
	direction = -player.get_transform().y.normalized()
	rotation = direction.angle()
	$DestructionTimer.start()

func _process(delta):
	position = position + direction * speed * delta


func hit():
	queue_free()
	
func _on_DestructionTimer_timeout():
	hit()


func _on_Bullet_body_entered(body):
	var collider = body
	print("Bullet collide with", collider)
	print("Parent is ", player)
	print(player != collider)
	if collider != player:
		print("hit")
		hit()
		if collider.has_method("hit"):
			collider.hit()
