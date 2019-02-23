extends Node2D


export var distance_from_borders = 200

export(int) var spawn_delay = 3

export(Array, String, FILE) var boost_list

var last_boost = null

func _ready():
	$SpawnDelayTimer.wait_time = spawn_delay;
	$SpawnDelayTimer.start()


func _on_SpawnDelayTimer_timeout():
	_spawn_boost();
	$SpawnDelayTimer.start();


func _spawn_boost():
	var rand_position = get_random_position()
	var boost_index = randi() % boost_list.size();
	var boost = load(boost_list[boost_index]).instance()
	boost.position = rand_position
	get_parent().add_child(boost)
	
	if(last_boost != null):
		last_boost.queue_free()
	last_boost = boost
	

func get_random_position():
	var max_x = int(get_viewport().get_visible_rect().end.x)
	var max_y = int(get_viewport().get_visible_rect().end.y)
	
	var rand_x = (randi() % (max_x - distance_from_borders * 2)) + distance_from_borders
	var rand_y = (randi() % (max_y - distance_from_borders * 2)) + distance_from_borders
	
	return Vector2(rand_x, rand_y)