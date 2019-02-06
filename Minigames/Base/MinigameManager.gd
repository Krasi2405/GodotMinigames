extends Node2D

export var player_count = 4

func _enter_tree():
	Global.MinigameManager = self


func get_player_count():
	return player_count