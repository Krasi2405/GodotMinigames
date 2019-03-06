extends Node2D

var SHIELD_PREFAB_PATH = "res://Minigames/Spaceship/Shield.tscn"

func apply_effect(player_ship):
	var shield = load(SHIELD_PREFAB_PATH).instance()
	player_ship.add_child(shield)
	player_ship.invulnereble = true
	