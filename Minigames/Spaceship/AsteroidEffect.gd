extends Node2D

export(String, FILE) var ASTEROID_PREFAB_PATH


func apply_effect(player_ship):
	var direction = -player_ship.get_transform().y.normalized()
	print("Load asteroid!")
	
	var asteroid = load(ASTEROID_PREFAB_PATH).instance()
	asteroid.set_direction(direction)
	asteroid.position = get_global_transform().get_origin()
	print("set position to ", position)
	Global.MinigameManager.add_child(asteroid)