extends Node2D

export var player_count = 4

var input_manager

var player_map = {}

var player_id_win_order = []



# TODO: Use bools in order to connect signals in _ready(). Performance reasons.
export var use_press_signal = true
export var use_hold_signal = true
export var use_release_signal = true

var is_game_over = false


func _enter_tree():
	Global.MinigameManager = self


func _ready():
	_remove_unused_players()
	
	var players = get_player_nodes();
	_create_player_map(players);


func win(player_id_win_order):
	print("Game over!", player_id_win_order)
	$WinText.parse_winners(player_id_win_order)
	


func get_player_count():
	return player_count


func remove_player(player_id):
	if player_id in player_id_win_order:
		return
	player_map.erase(player_id)
	player_count -= 1
	player_id_win_order.push_front(player_id)
	if player_count <= 1:
		$WinTimer.start()
		

func _on_WinTimer_timeout():
	win(player_id_win_order)
	$WinTimer.queue_free()


func get_player_nodes():
	var players = []
	for i in range(0, player_count):
		var player = get_node("PlayerController" + str(i))
		if player != null:
			players.append(player)
		else:
			print("Cannot get player_controller %s!" % i)
	return players
	

func _create_player_map(var players):
	var id = 0
	for player in players:
		player.player_id = id
		player_map[id] = player;
		id += 1


func _remove_unused_players():
	for i in range(player_count, 4):
		var unused_player = get_node("PlayerController" + str(i))
		if unused_player != null:
			unused_player.queue_free()


func _on_InputManager_on_button_press(button_id):
	if not use_press_signal:
		return

	if player_map.has(button_id):
		var player = player_map[button_id]
		player.press_action()


func _on_InputManager_on_button_hold(button_id, delta):
	if not use_press_signal:
		return
	
	if player_map.has(button_id):
		var player = player_map[button_id]
		player.hold_action(delta)


func _on_InputManager_on_button_release(button_id):
	if not use_press_signal:
		return
	
	if player_map.has(button_id):
		var player = player_map[button_id]
		player.release_action()


