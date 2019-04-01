extends Node2D

export(String, FILE) var SHIELD_PREFAB_PATH

func apply_effect(player_ship):
	var shield = load(SHIELD_PREFAB_PATH).instance()
	player_ship.add_child(shield)
	player_ship.invulnereble = true
	