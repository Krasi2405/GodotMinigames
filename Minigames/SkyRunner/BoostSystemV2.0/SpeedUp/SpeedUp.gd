extends Node2D


export var speed_boost_multiply = 1.25
export var speed_boost_time = 2

var default_player_speed : float
var player : Player

func _ready():
	($BoostTime as Timer).wait_time = speed_boost_time


func apply_effect(player : Player) -> void:
	default_player_speed = player.speed
	player.speed *= speed_boost_multiply
	self.player = player
	($BoostTime as Timer).start()
	print("Apply speed boost!")


func _on_BoostTime_timeout():
	self.player.speed = default_player_speed
