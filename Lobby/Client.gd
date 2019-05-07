extends Node

class_name Client


var thread : Thread
var lobby


func _ready():
	$SearchTimer.one_shot = true
	
	
	get_tree().connect("connected_to_server", self, "_connected_client")
	get_tree().connect("connection_failed", self, "_connection_failed")
	
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	lobby = Global.get_lobby()
	
	thread = Thread.new()
	thread.start(self, "setup_client")
	$"../Debug".print_d("Looking for connections\n")


func _connected_client():
	var id = lobby.get_network_peer().get_unique_id()
	var client = lobby.add_lobby_client(id)
	client.set_disconnect_btn_active(true)


func _connection_failed():
	$"../Debug".print_d("connection failed")


func _server_disconnected():
	$"../Debug".print_d("disconnected by server")
	lobby.reset_local_state()



func setup_client(userdata):
	var socket = PacketPeerUDP.new()
	socket.set_dest_address("255.255.255.255", lobby.get_dhcp_send_port())
	socket.put_packet("ip".to_ascii())
	socket.close()
	
	socket = PacketPeerUDP.new()
	if(socket.listen(lobby.get_dchp_get_port()) != OK):
		print("Error listening on port for ip")
		lobby.reset_local_state()
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
			$"../Debug".print_d("Could not find a server in time!")
			lobby.reset_local_state()
			return


	var peer = NetworkedMultiplayerENet.new()
	var result = peer.create_client(ip, 4242)
	if result != OK:
		print("Cannot create client")
		lobby.reset_local_state()
		return
	else:
		lobby.set_network_peer(peer)
		
	$"../Debug".print_d("Join\n")


func _exit_tree():
	thread.wait_to_finish()
	
	print("_exit_tree Client")