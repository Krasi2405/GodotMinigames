extends Node2D


export var distance_from_borders = 200

export(int) var spawn_delay = 3

export(Array, String, FILE) var boost_list

var boost_instances = []


func _ready():
	for boost in boost_list:
		boost_instances.push_back(load(boost))
	
	if not Global.lobby or is_network_master():
		$SpawnDelayTimer.wait_time = spawn_delay;
		$SpawnDelayTimer.start()


master func _on_SpawnDelayTimer_timeout():
	print("SpawnDelayTimer timeout")
	
	var boost_index = randi() % boost_list.size();
	var boost_position = _get_random_position()
	if Global.lobby:
		rpc("_spawn_boost", boost_position, boost_index)
	else:
		_spawn_boost(boost_position, boost_index);
	$SpawnDelayTimer.start();


puppetsync func _spawn_boost(boost_position : Vector2, boost_index : int):
	print("_spawn_boost")
	
	var boost = boost_instances[boost_index].instance()
	boost.position = boost_position
	Global.get_minigame_manager().add_child(boost)
	

func _get_random_position():
	var max_x = int(get_viewport().get_visible_rect().end.x)
	var max_y = int(get_viewport().get_visible_rect().end.y)
	
	var rand_x = (randi() % (max_x - distance_from_borders * 2)) + distance_from_borders
	var rand_y = (randi() % (max_y - distance_from_borders * 2)) + distance_from_borders
	
	return Vector2(rand_x, rand_y)