"""
Handles sending input to player controlers.
Handles player win order and win behaviour
Instantiation logic for everything
"""


extends Node2D

class_name MinigameManager

export var player_count := 4

var player_map : Dictionary = {}

var player_id_lose_order : Array = []
var player_id_win_order : Array = []

var active_player_count : int

var is_multiplayer_active := false
var lobby : Lobby

export var use_press_signal := true
export var use_hold_signal := true
export var use_release_signal := true

# Multiplayer variables
var synchronized_player_count = 0
var start_game_time : float
var peer : NetworkedMultiplayerENet
var current_player : Player


func _enter_tree() -> void:
	Global.set_minigame_manager(self)
	active_player_count = player_count


func _ready() -> void:
	_remove_unused_players()
	
	var players = get_player_nodes();
	_create_player_map(players);
	
	_bind_signals()
	
	lobby = Global.lobby
	if lobby:
		is_multiplayer_active = true
		peer = lobby.get_network_peer()
		
		var order = lobby.get_user_order_by_id(peer.get_unique_id())
		print("Got order: " + str(order))
		for x in range(player_count):
			if x != order:
				Global.input_manager.remove_button(x)
		
		current_player = get_node("PlayerController" + str(order) + "/Player")
		current_player.set_network_master(peer.get_unique_id())

		get_tree().set_pause(true)
		print("rpc synchronize!")
		rpc_id(1, "_synchronize")


remotesync func _synchronize():
	if is_network_master():
		synchronized_player_count += 1
		if synchronized_player_count == player_count:
			var game_time = OS.get_ticks_msec()
			rpc("_start_game", game_time)


remotesync func _start_game(start_time):
	start_game_time = start_time
	get_tree().set_pause(false)

	print("Start game at " + str(start_game_time))
	

func get_player_nodes() -> Array:
	var players : = []
	for i in range(0, player_count):
		var player : = get_node("PlayerController" + str(i)) as PlayerController
		if player != null:
			players.append(player)
		else:
			print("Cannot get player_controller %s!" % i)
	return players


func get_player_count() -> int:
	return active_player_count


func _bind_signals() -> void:
	if use_press_signal:
		Global.get_input_manager().connect("on_button_press", self, "_on_InputManager_on_button_press")
		
	if use_hold_signal:
		Global.get_input_manager().connect("on_button_hold", self, "_on_InputManager_on_button_hold")
	
	if use_release_signal:
		Global.get_input_manager().connect("on_button_release", self, "_on_InputManager_on_button_release")


master func add_loser(player_id : int) -> void:
	_add_player_to_list(player_id, player_id_lose_order, true)


master func add_winner(player_id : int) -> void:
	print("Add winner called!")
	_add_player_to_list(player_id,  player_id_win_order, false)


func _add_player_to_list(player_id : int, list : Array, should_push_front : bool) -> void:
	if active_player_count <= 0 or not player_map.has(player_id):
		return

	player_map.erase(player_id)
	active_player_count -= 1
	if should_push_front:
		list.push_front(player_id)
	else:
		list.push_back(player_id)

	if $OnWinDelayTimer && active_player_count <= 1:
		($OnWinDelayTimer as Timer).start()


func _on_WinTimer_timeout() -> void:
	var ranking_list := []
	for player_id in player_id_win_order:
		ranking_list.append(player_id)
	
	print("win order: ", player_id_win_order)
	for player_id in player_id_lose_order:
		ranking_list.append(player_id)
	print("lose order: ", player_id_lose_order)

	# Cleanup player_map. Scraps everything together but really ugly
	for player_id in player_map.keys():
		ranking_list.push_front(player_id)
	
	if is_multiplayer_active:
		rpc("win", ranking_list)
	else:
		win(ranking_list)
	
	$OnWinDelayTimer.queue_free()


remotesync func win(player_id_win_order) -> void:
	print("Game over!", player_id_win_order)
	($CanvasLayer/WinText as WinText).parse_winners(player_id_win_order)
	# Nz zashto obache inache ne raboti.
	if $CanvasLayer/InputManager:
		($CanvasLayer/InputManager).queue_free()
	($OnVictoryRestartTimer as Timer).start()


func _on_OnVictoryRestartTimer_timeout() -> void:
	if is_multiplayer_active:
		Global.lobby.show()
		queue_free()
	else:
		get_tree().reload_current_scene()


func _create_player_map(var players : Array) -> void:
	var id = 0
	for player in players:
		player.player_id = id
		player_map[id] = player;
		id += 1


func _remove_unused_players() -> void:
	for i in range(player_count, 4):
		var unused_player : = get_node("PlayerController" + str(i)) as PlayerController
		if unused_player != null:
			unused_player.queue_free()


func _on_InputManager_on_button_press(button_id : int) -> void:
	if not use_press_signal:
		return
	
	if is_multiplayer_active:
		rpc("press_button", button_id)
	else:
		press_button(button_id)


func _on_InputManager_on_button_hold(button_id : int, delta : float) -> void:
	if not use_hold_signal:
		return
	
	if is_multiplayer_active:
		rpc("hold_button", button_id, delta)
	else:
		hold_button(button_id, delta)


func _on_InputManager_on_button_release(button_id : int) -> void:
	if not use_release_signal:
		return
	
	if is_multiplayer_active:
		rpc("release_button", button_id)
	else:
		release_button(button_id)


remotesync func press_button(button_id : int) -> void:
	if player_map.has(button_id):
		var player : PlayerController = player_map[button_id]
		player.press_action()


remotesync func hold_button(button_id : int, delta : float) -> void:
	if player_map.has(button_id):
		var player : PlayerController = player_map[button_id]
		player.hold_action(delta)


remotesync func release_button(button_id : int) -> void:
	if player_map.has(button_id):
		var player : PlayerController = player_map[button_id]
		player.release_action()


func _get_button_player(button_id : int) -> PlayerController:
	return player_map[button_id]