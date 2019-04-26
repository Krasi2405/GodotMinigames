extends Control


export(Array, Color) var colors : Array
var user_count := 0

var lobby_user_resource = preload("res://Lobby/LobbyUser.tscn")
var host_icon = preload("res://Lobby/HostIcon.png")
var client_icon = preload("res://Lobby/ClientIcon.png")


var local_user : LobbyUser
var users : Array


func level_load(player_count : int) -> void:
	pass


func _ready():
	assert(colors.size() >= 4)
	$LeaveBTN.visible = false


func _on_HostBTN_button_down():
	create_game()


func _on_JoinBTN_button_down():
	join_game()


func _on_LeaveBTN_button_down():
	pass # Replace with function body.


func create_game():
	remove_join_btns()
	local_user = add_host()
	local_user.set_disconnect_btn_active(true)


func join_game():
	remove_join_btns()
	local_user = add_client()
	local_user.set_disconnect_btn_active(true)


func add_host() -> LobbyUser:
	var host := add_user("Host", host_icon, true)
	return host


func add_client() -> LobbyUser:
	var client := add_user("Client", client_icon, false)
	return client


func remove_join_btns() -> void:
	$JoinBTN.visible = false
	$HostBTN.visible = false
	$LeaveBTN.visible = true


func add_user(username : String, icon : Texture, is_host : bool) -> LobbyUser:
	if(user_count >= 4):
		return null
	
	var user := lobby_user_resource.instance() as LobbyUser
	user.initalize(username, colors[user_count], icon, is_host)
	user.set_disconnect_btn_active(false)
	user_count += 1

	user.connect("leave_button_pressed", self, "disconnect_user")	

	users.append(user)
	$CenterContainer/Users.add_child(user)
	return user


func disconnect_user(index : int):
	var local_user_id = local_user.get_id()
	if index == local_user_id:
		print("Disconnect self")
		$JoinBTN.show()
		$HostBTN.show()
	
	$CenterContainer/Users.remove_child(users[index])
	users.remove(index)
	user_count -= 1

