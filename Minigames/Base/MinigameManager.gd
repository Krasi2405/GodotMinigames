extends Node2D

export var player_count = 4

var input_manager
var players = {}



# TODO: Use bools in order to connect signals in _ready(). Performance reasons.
export var use_press_signal = true
export var use_hold_signal = true
export var use_release_signal = true


func _enter_tree():
	Global.MinigameManager = self


func _ready():
	remove_unused_players()
	
	self.players = get_player_nodes();
	set_player_ids();


func get_player_nodes():
	var players = []
	for i in range(0, player_count):
		var player = get_node("PlayerController" + str(i))
		if player != null:
			players.append(player)
		else:
			print("Cannot get player_controller %s!" % i)
	return players
	

func set_player_ids():
	var id = 0
	for player in self.players:
		player.player_id = id
		id += 1


func remove_unused_players():
	for i in range(player_count, 4):
		var unused_player = get_node("PlayerController" + str(i))
		if unused_player != null:
			unused_player.queue_free()


func get_player_count():
	return player_count


func _on_InputManager_on_button_press(button_id):
	if not use_press_signal:
		return

	var player = players[button_id]
	player.press_action()


func _on_InputManager_on_button_hold(button_id, delta):
	if not use_press_signal:
		return
	
	var player = players[button_id]
	player.hold_action(delta)


func _on_InputManager_on_button_release(button_id):
	if not use_press_signal:
		return
	
	var player = players[button_id]
	player.release_action()
