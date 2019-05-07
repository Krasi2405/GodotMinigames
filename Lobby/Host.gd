extends Node

class_name Host

var thread : Thread
var mutex : Mutex
var should_exit_thread = false
var lobby


func _ready():
	mutex = Mutex.new()
	lobby = Global.get_lobby()
	start_server()
	

func start_server() -> void:
	var peer = NetworkedMultiplayerENet.new()
	var result = peer.create_server(4242, 4)
	if result != OK:
		print("Cannot create server")
	else:
		thread = Thread.new()
		thread.start(self, "handle_dhcp_requests")

		lobby.add_lobby_host().set_disconnect_btn_active(true)
		lobby.set_network_peer(peer)
		print(peer.get_unique_id())
	
	$"../Debug".print_d("Create server\n")


func handle_dhcp_requests(userdata):
	print("handle_dhcp_requests")
	var socket := PacketPeerUDP.new()

	if socket.listen(lobby.get_dhcp_send_port()) != OK:
		print("Cannot listen for ip requests")
		lobby.reset_local_state()
		return
	else:
		print("Listening for ip requests")

	while true:
		if socket.get_available_packet_count() > 0:
			var data = socket.get_packet().get_string_from_ascii()
			
			print("Data received: " + data)
			socket.set_dest_address(socket.get_packet_ip(), lobby.get_dchp_get_port())
			socket.put_packet("123".to_ascii())
			print("Send data to " + socket.get_packet_ip() + ":" + str(lobby.get_dchp_get_port()))
			
		mutex.lock()
		if(should_exit_thread):
			socket.close()
			mutex.unlock()
			break
		mutex.unlock()


func _exit_tree():
	mutex.lock()
	should_exit_thread = true
	mutex.unlock()
	thread.wait_to_finish()
	
	print("_exit_tree Host")
	
	
	
	