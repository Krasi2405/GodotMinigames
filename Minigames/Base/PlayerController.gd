"""
Sends input down the chain to the player.
"""


extends Node2D

class_name PlayerController

var player_id = 0
var player : Player

func _ready():
	assert($Player != null)
	player = ($Player as Player)



func press_action():
	player.press_action()


func hold_action(delta : float):
	player.hold_action(delta)


func release_action():
	player.release_action()


func die():
	get_parent().remove_player(player_id)
	queue_free()
	