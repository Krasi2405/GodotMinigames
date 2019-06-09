extends Control

class_name Lobby

export(Array, Color) var colors : Array
var user_count := 0

var lobby_user_resource = preload("res://Lobby/LobbyUser.tscn")
var host_icon = preload("res://Lobby/HostIcon.png")
var client_icon = preload("res://Lobby/ClientIcon.png")
var host_prefab = preload("res://Lobby/Host.tscn")
var client_prefab = preload("res://Lobby/Client.tscn")


var users : Array

var host
var client

const DHCP_SEND_PORT = 4243
const DHCP_GET_PORT = 4244


func _ready():
	assert(colors.size() >= 4)
	
	Global.set_lobby(self)
	
	# Everybody gets it including server
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")


func get_dhcp_send_port() -> int:
	return DHCP_SEND_PORT


func get_dchp_get_port() -> int:
	return DHCP_GET_PORT


func _player_connected(id):
	$Debug.print_d("Connect player with id " + str(id))
	# id == 1 is server
	if(id == 1):
		add_lobby_host()
	else:
		add_lobby_client(id)
	_hide_join_btns()


func _player_disconnected(id):
	$Debug.print_d("Disconnect player with id " + str(id))
	var user := get_user_by_id(id)
	$CenterContainer/Users.remove_child(user)
	users.erase(user)
	user_count -= 1


func _on_HostBTN_button_down():
	print("host button down")
	_hide_join_btns()
	host = host_prefab.instance()
	add_child(host)


func _on_JoinBTN_button_down():
	_hide_join_btns()
	client = client_prefab.instance()
	add_child(client)


func add_lobby_host() -> LobbyUser:
	var lobby_user := add_lobby_user(1, "Host", host_icon)
	return lobby_user


func add_lobby_client(id : int) -> LobbyUser:
	var client := add_lobby_user(id, "Client", client_icon)
	if(get_tree().is_network_server()):
		client.set_disconnect_btn_active(true)
	return client


func add_lobby_user(id : int, username : String, icon : Texture) -> LobbyUser:
	if user_count >= 4:
		return null
	
	var user := lobby_user_resource.instance() as LobbyUser
	user.initalize(str(id), colors[user_count], icon)
	user.set_disconnect_btn_active(false)
	user.set_network_id(id)
	user_count += 1

	user.connect("leave_button_pressed", self, "give_disconnect_signal")
	print("add user with id ", id)
	users.append(user)
	$CenterContainer/Users.add_child(user)
	return user


func give_disconnect_signal(id : int) -> void:
	rpc("_disconnect_user", id)


remotesync func _disconnect_user(id : int) -> void:
	print("disconnected: ", id)
	if get_tree().is_network_server():
		if id == get_network_peer().get_unique_id():
			$Debug.print_d("Stop server")
			reset_local_state()
		else:
			get_network_peer().disconnect_peer(id)


func _hide_join_btns() -> void:
	$JoinBTN.hide()
	$HostBTN.hide()


func _show_join_btns() -> void:
	$JoinBTN.show()
	$HostBTN.show()


func reset_local_state():
	_close_network()
	_reset_GUI()
	
	user_count = 0
	users = []


func _close_network():
	if host:
		host.queue_free()
	
	if client:
		client.queue_free()
	
	var peer := get_network_peer()
	if peer == null:
		return

	if peer.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
		peer.call_deferred("close_connection")
	
	call_deferred("set_network_peer", null)


func _reset_GUI():
	for child in $CenterContainer/Users.get_children():
		$CenterContainer/Users.remove_child(child)
	
	_remove_level_picker()
	_show_join_btns()


func get_network_peer() -> NetworkedMultiplayerENet:
	if get_tree().has_meta("network_peer"):
		return get_tree().get_meta("network_peer") as NetworkedMultiplayerENet
	else:
		return null


func set_network_peer(peer : NetworkedMultiplayerENet) -> void:
	get_tree().set_network_peer(peer)
	get_tree().call_deferred("set_meta", "network_peer", peer)


func get_user_count() -> int:
	return user_count;


func load_level_picker(player_count : int) -> void:
	print("Load level picker with " + str(player_count))
	if player_count >= 2 and player_count <= 4:
		var level_picker = load(
			"res://LevelPicker/" + str(player_count) + "PLevelPicker.tscn"
		).instance()
		level_picker.connect("choose_level", self, "load_level_signal")
		
		_remove_level_picker()

		$LevelPickerContainer.add_child(level_picker)


func _remove_level_picker():
	for child in $LevelPickerContainer.get_children():
		child.queue_free()


func load_level_signal(level : String):
	rpc("load_level", level)


remotesync func load_level(level : String):
	var level_instance = load(level).instance()
	add_child(level_instance)


func get_user_by_id(id : int) -> LobbyUser:
	for user in users:
		if user.get_network_id() == id:
			return user
	return null


func get_user_order_by_id(id : int) -> int:
	var order := 0
	for user in users:
		if user.get_network_id() == id:
			return order
		order += 1
	return -1


func _exit_tree():
	Global.lobby = null;