extends Node2D


var SHOOTER_RESOURCES = preload("res://Minigames/Spaceship/Boosts/Shoot/Shooter.tscn")

func apply_effect(player_ship):
	var shooter = SHOOTER_RESOURCES.instance()
	shooter.player = player_ship
	player_ship.add_child(shooter)
