"""
Placeholder for showing the winners.
"""

extends Control

class_name WinText

var FIRST_PLACE_PNG = preload("res://trophy1.png")
var SECOND_PLACE_PNG = preload("res://trophy2.png")
var THIRD_PLACE_PNG = preload("res://trophy3.png")
var FORTH_PLACE_PNG = preload("res://trophy4.png")

var thropies = [FIRST_PLACE_PNG,SECOND_PLACE_PNG,THIRD_PLACE_PNG,FORTH_PLACE_PNG]

func _ready():
	parse_winners([1, 4, 2, 3])



func parse_winners(player_id_win_order : Array):
	for index in player_id_win_order.size():
		var thropy = thropies[index]
		var player_id = player_id_win_order[index]
		
		(get_node("TextureRect" + str(player_id)) as TextureRect).texture = thropy
		
		
	