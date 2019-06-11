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
	print("press action " + str(player_id))
	if Global.lobby and is_network_master():
		print("in press action synchronize " + str(player_id))
		player.press_action_synchronize()


func hold_action(delta : float) -> void:
	player.hold_action(delta)
	emit_signal("hold_action", delta)
	if Global.lobby and is_network_master():
		player.hold_action_synchronize()


func release_action() -> void:
	player.release_action()
	emit_signal("release_action")
	if Global.lobby and is_network_master():
		player.release_action_synchronize()


func die() -> void:
	print("Die")
	if Global.lobby:
		if is_network_master():
			rpc("_die")
	else:
		_die()


remotesync func _die():
	if not Global.lobby or is_network_master():
		get_parent().add_loser(player_id)
	queue_free()


func win() -> void:
	if Global.lobby:
		if is_network_master():
			rpc("_win")
	else:
		_win()


remotesync func _win() -> void:
	if not Global.lobby or is_network_master():
		get_parent().add_winner(player_id)


func get_player_child() -> Player:
	return ($Player as Player)