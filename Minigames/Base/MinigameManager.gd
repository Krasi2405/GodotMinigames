extends Node2D

export var player_count = 4

var input_manager
var players = []


func _enter_tree():
	Global.MinigameManager = self


func _ready():
	players = get_player_nodes()
	remove_unused_players()
	

func get_player_nodes():
	var players = []
	for i in range(0, player_count):
		var player = get_node("PlayerController" + str(i))
		if player != null:
			players.append(player)
		else:
			print("Cannot get player_controller %s!" % i)
	return players


func remove_unused_players():
	for i in range(player_count, 4):
		var unused_player = get_node("PlayerController" + str(i))
		if unused_player != null:
			unused_player.queue_free()


func get_player_count():
	return player_count


func _on_InputManager_on_button_press(button_id):
	print("press %s" % button_id)


func _on_InputManager_on_button_hold(button_id):
	print("hold %s" % button_id)


func _on_InputManager_on_button_release(button_id):
	print("release %s" % button_id)
