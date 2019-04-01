extends Node2D


var SHOOTER_PREFAB_PATH = "res://Minigames/Spaceship/Boosts/Shoot/Shooter.tscn"

func apply_effect(player_ship):
	var shooter = load(SHOOTER_PREFAB_PATH).instance()
	shooter.player = player_ship
	player_ship.add_child(shooter)
