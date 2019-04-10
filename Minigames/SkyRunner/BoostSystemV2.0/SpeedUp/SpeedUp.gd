extends Node2D


export var speed_boost_multiply = 1.25
export var speed_boost_time = 2

var default_player_speed : float
var player : Player

func _ready():
	($BoostTime as Timer).wait_time = speed_boost_time


func apply_effect(player : Player) -> void:
	default_player_speed = player.movement_speed
	player.motion.x *= speed_boost_multiply
	self.player = player
	
	($BoostTime as Timer).start()
	$"../Animation".modulate.a = 0.5


func _on_BoostTime_timeout():
	if weakref(player).get_ref():
		self.player.motion.x = default_player_speed
	$"../Animation".modulate.a = 1