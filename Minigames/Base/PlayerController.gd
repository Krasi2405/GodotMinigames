"""
Sends input down the chain to the player.
"""


extends Node2D

class_name PlayerController

signal press_action()
signal hold_action(delta)
signal release_action()

var player_id = 0
var player : Player

func _ready() -> void:
	assert($Player != null)
	player = ($Player as Player)



func press_action() -> void:
	player.press_action()
	emit_signal("press_action")


func hold_action(delta : float) -> void:
	player.hold_action(delta)
	emit_signal("hold_action", delta)


func release_action() -> void:
	player.release_action()
	emit_signal("release_action")


func die() -> void:
	get_parent().remove_player(player_id)
	queue_free()


func win() -> void:
	print("Player with id ", player_id + " has won!")


func get_player_child() -> Player:
	return ($Player as Player)