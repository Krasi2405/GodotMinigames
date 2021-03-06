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


func parse_winners(player_id_win_order : Array):
	show()
	for index in player_id_win_order.size():
		var thropy = thropies[index]
		var player_id = player_id_win_order[index]
		
		var trophy_node_name = "TextureRect" + str(player_id + 1)
		(get_node(trophy_node_name) as TextureRect).texture = thropy