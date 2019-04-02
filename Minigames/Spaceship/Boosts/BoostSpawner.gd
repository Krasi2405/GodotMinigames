extends Node2D


export var distance_from_borders = 200

export(int) var spawn_delay = 3

export(Array, String, FILE) var boost_list

var boost_instances = []


func _ready():
	for boost in boost_list:
		boost_instances.push_back(load(boost))

	$SpawnDelayTimer.wait_time = spawn_delay;
	$SpawnDelayTimer.start()


func _on_SpawnDelayTimer_timeout():
	_spawn_boost();
	$SpawnDelayTimer.start();


func _spawn_boost():
	var boost_index = randi() % boost_list.size();
	var boost = boost_instances[boost_index].instance()
	boost.position = _get_random_position()
	Global.MinigameManager.add_child(boost)
	

func _get_random_position():
	var max_x = int(get_viewport().get_visible_rect().end.x)
	var max_y = int(get_viewport().get_visible_rect().end.y)
	
	var rand_x = (randi() % (max_x - distance_from_borders * 2)) + distance_from_borders
	var rand_y = (randi() % (max_y - distance_from_borders * 2)) + distance_from_borders
	
	return Vector2(rand_x, rand_y)