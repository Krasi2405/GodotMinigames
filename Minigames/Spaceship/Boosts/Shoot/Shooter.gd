extends Node2D


export var shoot_delay = 3
export var bullet_count = 3 

var BULLET_PREFAB = "res://Minigames/Spaceship/Boosts/Shoot/Bullet.tscn"

var player

func _ready():
	$ShootTimer.wait_time = shoot_delay
	$ShootTimer.start()
	position = player.position
	shoot()
	

func _process(delta):
	position = player.position


func _on_ShootTimer_timeout():
	shoot()
		
func shoot():
	print("Shoot")
	bullet_count -= 1
	var bullet = load(BULLET_PREFAB).instance()
	bullet.player = player
	bullet.position = position
	Global.MinigameManager.add_child(bullet)
	print("Instantiate bullet at ", bullet.position)
	if bullet_count <= 0:
		queue_free()
