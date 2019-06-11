extends Node2D

export var spawn_timer = 3
export var lower_time_per_spawn = 0.05
export var min_timer = 1.5

export(String, FILE) var ASTEROID_PREFAB_PATH

export var x_direction_offset = 320
export var y_direction_offset = 180

var asteroid_instance

var center;

func _enter_tree():
	asteroid_instance = load(ASTEROID_PREFAB_PATH)


master func _ready():
	print("Is network master!")
	var size_x = get_viewport().size.x
	var size_y = get_viewport().size.y
	center = Vector2(size_x / 2, size_y / 2)
	
	$SpawnTimer.wait_time = spawn_timer
	$SpawnTimer.start()


master func _on_SpawnTimer_timeout():
	if spawn_timer > min_timer:
		spawn_timer -= lower_time_per_spawn
		$SpawnTimer.wait_time = spawn_timer
	
	
	var spawn_position = get_random_spawn_position()
	var rand_direction = get_random_direction_position()
	
	if Global.lobby:
		rpc("spawn", spawn_position, rand_direction)
	else:
		spawn(spawn_position, rand_direction)
	$SpawnTimer.start()


# Rotate around center of screen and spawn asteroid around the edges
func get_random_spawn_position() -> Vector2:
	randomize()
	var rand_angle = rand_range(0, 360) * PI / 180
	rotation = rand_angle
	
	var hypotenuse = get_hypotenuse_length_by_offset(center)
	var forward = -get_transform().y.normalized()
	
	var spawn_position = center + forward * hypotenuse
	return spawn_position


remotesync func spawn(spawn_position : Vector2, rand_direction : Vector2):
	var direction_vector = Vector2(spawn_position.x - rand_direction.x,
									spawn_position.y - rand_direction.y)
	rotation = -atan2(direction_vector.x, 
						direction_vector.y)
	var asteroid_direction = -get_transform().y.normalized()

	
	var asteroid = asteroid_instance.instance()
	asteroid.set_direction(asteroid_direction)
	asteroid.position = spawn_position
	Global.get_minigame_manager().call_deferred("add_child", asteroid)


func get_hypotenuse_length_by_offset(offset : Vector2):
	return sqrt(offset.x * offset.x + offset.y * offset.y)
	

func get_random_direction_position() -> Vector2:
	randomize()
	var random_x = center.x + rand_range(-x_direction_offset, x_direction_offset)
	var random_y = center.y + rand_range(-y_direction_offset, y_direction_offset)
	
	return Vector2(random_x, random_y)