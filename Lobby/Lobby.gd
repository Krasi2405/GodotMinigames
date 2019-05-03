extends Control


export(Array, Color) var colors : Array
var user_count := 0

var lobby_user_resource = preload("res://Lobby/LobbyUser.tscn")
var host_icon = preload("res://Lobby/HostIcon.png")
var client_icon = preload("res://Lobby/ClientIcon.png")


var local_user : LobbyUser
var users : Dictionary

var thread : Thread
var mutex : Mutex
var should_exit_thread = false

var server_ip : String

const DHCP_GET_PORT = 4245
const DHCP_SEND_PORT = 4244


func _ready():
	assert(colors.size() >= 4)
	mutex = Mutex.new()
	
	# Everybody gets it including server
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
	# Only on clients
	get_tree().connect("connected_to_server", self, "_connected_client")
	get_tree().connect("connection_failed", self, "_connection_failed")
	
	# Get kicked out by server
	get_tree().connect("server_disconnected", self, "_server_disconnected")


func _player_connected(id):
	$Debug.send_debug("Connect player with id " + str(id))
	# id == 1 is server
	if(id == 1):
		add_lobby_host()
	else:
		add_lobby_client()
	remove_join_btns()


func _player_disconnected(id):
	$Debug.send_debug("Connect player with id " + str(id))


func _connected_client():
	var client := add_lobby_client()
	client.set_disconnect_btn_active(true)
	$Debug.send_debug("connected")


func _connection_failed():
	$Debug.send_debug("connection failed")


func _server_disconnected():
	$Debug.send_debug("disconnected")


func _on_HostBTN_button_down():
	remove_join_btns()
	
	print("Create server")
	var peer = NetworkedMultiplayerENet.new()
	var result = peer.create_server(4242, 4)
	if result != OK:
		print("Cannot create server")
	else:
		thread = Thread.new()
		thread.start(self, "handle_dhcp_requests")

		add_lobby_host().set_disconnect_btn_active(true)
		get_tree().set_network_peer(peer)
		get_tree().set_meta("network_peer", peer)
	
	$Debug.send_debug("Create server\n")


func handle_dhcp_requests(userdata):
	print(userdata)
	print("handle_dhcp_requests")
	var socket = PacketPeerUDP.new()
	if socket.listen(DHCP_SEND_PORT) != OK:
		print("Cannot listen for ip requests")
		return
	else:
		print("Listening for ip requests")

	while true:
		if socket.get_available_packet_count() > 0:
			var data = socket.get_packet().get_string_from_ascii()
			
			print("Data received: " + data)
			socket.set_dest_address(socket.get_packet_ip(), DHCP_GET_PORT)
			socket.put_packet("123".to_ascii())
			print("Send data to " + socket.get_packet_ip() + ":" + str(DHCP_GET_PORT))
			
			mutex.lock()
			if(should_exit_thread):
				mutex.unlock()
				break
			mutex.unlock()


func _on_JoinBTN_button_down():
	remove_join_btns()

	print("Create client")
	
	thread = Thread.new()
	thread.start(self, "setup_client")

	$Debug.send_debug("Looking for connections\n")


func setup_client(userdata):
	var socket = PacketPeerUDP.new()
	socket.set_dest_address("255.255.255.255", DHCP_SEND_PORT)
	socket.put_packet("ip".to_ascii())
	socket.close()
	
	socket = PacketPeerUDP.new()
	if(socket.listen(DHCP_GET_PORT) != OK):
		print("Error listening on port for ip")
		return
	else:
		print("Listening on port for server's ip")

	var ip : String
	while true:
		if socket.get_available_packet_count() > 0:
			var data = socket.get_packet()
			ip = socket.get_packet_ip()
			print("Got ip data with ip " + ip)
			break

	var peer = NetworkedMultiplayerENet.new()
	var result = peer.create_client(ip, 4242)
	if result != OK:
		print("Cannot create client")
		return
	else:
		get_tree().set_network_peer(peer)
		get_tree().set_meta("network_peer", peer)
		
	$Debug.send_debug("Join\n")


func add_lobby_host() -> LobbyUser:
	var lobby_user := add_user(1, "Host", host_icon)
	return lobby_user


func add_lobby_client() -> LobbyUser:
	var client := add_user(1, "Client", client_icon)
	if(get_tree().is_network_server()):
		client.set_disconnect_btn_active(true)
	return client


func add_user(id : int, username : String, icon : Texture) -> LobbyUser:
	if(user_count >= 4):
		return null
	
	var user := lobby_user_resource.instance() as LobbyUser
	user.initalize(username, colors[user_count], icon)
	user.set_disconnect_btn_active(false)
	user_count += 1

	user.connect("leave_button_pressed", self, "disconnect_user")	
	users[id] = user
	$CenterContainer/Users.add_child(user)
	return user


func disconnect_user(id : int):
	var local_user_id = local_user.get_id()
	if id == local_user_id:
		reset_local_state()
	else:
		$CenterContainer/Users.remove_child(users[id])
		users.erase(id)
		user_count -= 1


func remove_join_btns() -> void:
	$JoinBTN.visible = false
	$HostBTN.visible = false


func reset_local_state():
	$JoinBTN.show()
	$HostBTN.show()
	
	user_count = 0
	users = {}
	local_user = null
	
	for child in $CenterContainer/Users.get_children():
		$CenterContainer/Users.remove_child(child)
		
func _exit_tree():
	mutex.lock()
	should_exit_thread = true
	mutex.unlock()
	thread.wait_to_finish()