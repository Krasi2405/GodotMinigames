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


func _ready():
	var size_x = get_viewport().size.x
	var size_y = get_viewport().size.y
	center = Vector2(size_x / 2, size_y / 2)
	
	$SpawnTimer.wait_time = spawn_timer
	$SpawnTimer.start()
	spawn()

func _on_SpawnTimer_timeout():
	if spawn_timer > min_timer:
		spawn_timer -= lower_time_per_spawn
		$SpawnTimer.wait_time = spawn_timer
	
	spawn()
	$SpawnTimer.start()



# WTF SE SLUCHVA TUKA!?!?!?!?!?!?
# TUI STANA PULNO LAINO.
func spawn():
	randomize()
	var rand_angle = rand_range(0, 360) * PI / 180
	rotation = rand_angle
	
	var hypotenuse = get_hypotenuse_length_by_offset(center)
	var forward = -get_transform().y.normalized()
	
	var spawn_position = center + forward * hypotenuse
	
	var rand_direction = get_random_direction_position()
	
	var direction_vector = Vector2(spawn_position.x - rand_direction.x,
									spawn_position.y - rand_direction.y)
	rotation = -atan2(direction_vector.x, 
						direction_vector.y)
	var asteroid_direction = -get_transform().y.normalized()

	
	var asteroid = asteroid_instance.instance()
	asteroid.set_direction(asteroid_direction)
	asteroid.position = spawn_position
	Global.get_minigame_manager().call_deferred("add_child", asteroid)

# Offset is Vector2
func get_hypotenuse_length_by_offset(offset):
	return sqrt(offset.x * offset.x + offset.y * offset.y)
	
func get_random_direction_position():
	randomize()
	var random_x = center.x + rand_range(-x_direction_offset, x_direction_offset)
	var random_y = center.y + rand_range(-y_direction_offset, y_direction_offset)
	
	return Vector2(random_x, random_y)

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	