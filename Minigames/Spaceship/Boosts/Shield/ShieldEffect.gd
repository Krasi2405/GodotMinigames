extends Node2D

export(String, FILE) var SHIELD_PREFAB_PATH
var shield_resource

func _enter_tree():
	shield_resource = load(SHIELD_PREFAB_PATH)


func apply_effect(player_ship):
	var shield = shield_resource.instance()
	player_ship.add_child(shield)
	player_ship.invulnereble = true
	