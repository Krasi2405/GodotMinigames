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
	$Debug.print_d("Connect player with id " + str(id))
	# id == 1 is server
	if(id == 1):
		add_lobby_host()
	else:
		add_lobby_client(id)
	remove_join_btns()


func _player_disconnected(id):
	$Debug.print_d("Disonnect player with id " + str(id))


func _connected_client():
	var id := get_network_peer().get_unique_id()
	var client := add_lobby_client(id)
	client.set_disconnect_btn_active(true)
	$Debug.print_d("connected")


func _connection_failed():
	$Debug.print_d("connection failed")


func _server_disconnected():
	$Debug.print_d("disconnected by server")
	reset_local_state()


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
		print(peer.get_unique_id())
	
	$Debug.print_d("Create server\n")


func handle_dhcp_requests(userdata):
	print("handle_dhcp_requests")
	var socket := PacketPeerUDP.new()

	if socket.listen(DHCP_SEND_PORT) != OK:
		print("Cannot listen for ip requests")
		reset_local_state()
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

	$Debug.print_d("Looking for connections\n")


func setup_client(userdata):
	var socket = PacketPeerUDP.new()
	socket.set_dest_address("255.255.255.255", DHCP_SEND_PORT)
	socket.put_packet("ip".to_ascii())
	socket.close()
	
	socket = PacketPeerUDP.new()
	if(socket.listen(DHCP_GET_PORT) != OK):
		print("Error listening on port for ip")
		reset_local_state()
		return
	else:
		print("Listening on port for server's ip")

	var ip : String
	$SearchTimer.start()
	while true:
		if socket.get_available_packet_count() > 0:
			var data = socket.get_packet()
			ip = socket.get_packet_ip()
			print("Got ip data with ip " + ip)
			break

		if $SearchTimer.get_time_left() == 0:
			$Debug.print_d("Could not find a server in time!")
			reset_local_state()
			return

	var peer = NetworkedMultiplayerENet.new()
	var result = peer.create_client(ip, 4242)
	if result != OK:
		print("Cannot create client")
		return
	else:
		get_tree().set_network_peer(peer)
		get_tree().set_meta("network_peer", peer)
		
	$Debug.print_d("Join\n")


func add_lobby_host() -> LobbyUser:
	var lobby_user := add_user(1, "Host", host_icon)
	return lobby_user


func add_lobby_client(id : int) -> LobbyUser:
	var client := add_user(id, "Client", client_icon)
	if(get_tree().is_network_server()):
		client.set_disconnect_btn_active(true)
	return client


func add_user(id : int, username : String, icon : Texture) -> LobbyUser:
	if(user_count >= 4):
		return null
	
	var user := lobby_user_resource.instance() as LobbyUser
	user.initalize(username, colors[user_count], icon)
	user.set_disconnect_btn_active(false)
	user.set_id(id)
	user_count += 1

	user.connect("leave_button_pressed", self, "disconnect_local")
	print("add user with id ", id)
	users[id] = user
	$CenterContainer/Users.add_child(user)
	return user

func disconnect_local(id : int) -> void:
	rpc("disconnect_user", id)


remotesync func disconnect_user(id : int) -> void:
	print("disconnected: ", id)
	if get_tree().is_network_server():
		if id == get_network_peer().get_unique_id():
			$Debug.print_d("Stop server")
			get_network_peer().close_connection()
			reset_local_state()
		else:
			get_network_peer().disconnect_peer(id)
			$CenterContainer/Users.remove_child(users[id])
			users.erase(id)
			user_count -= 1
	
	

	


func remove_join_btns() -> void:
	$JoinBTN.hide()
	$HostBTN.hide()


func reset_local_state():
	user_count = 0
	users = {}
	local_user = null
	
	get_tree().set_network_peer(null)
	
	for child in $CenterContainer/Users.get_children():
		$CenterContainer/Users.remove_child(child)
	
	$JoinBTN.show()
	$HostBTN.show()
	
	exit_thread()
	


func _exit_tree():
	exit_thread()
	


func exit_thread():
	mutex.lock()
	should_exit_thread = true
	mutex.unlock()
	thread.wait_to_finish()


func get_network_peer() -> NetworkedMultiplayerENet:
	return get_tree().get_meta("network_peer") as NetworkedMultiplayerENet