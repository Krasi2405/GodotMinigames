class_name Node2DSynchronizationComponent

extends Node

var is_in_multiplayer = false

func _ready():
	var lobby := Global.get_lobby()
	if lobby:
		is_in_multiplayer = true
		var peer := lobby.get_network_peer()
		get_parent().set_network_master(peer.get_unique_id())
		acquire_control_of_property("position")
		acquire_control_of_property("rotation")
		acquire_control_of_property("scale")


func acquire_control_of_property(property_name : String):
	get_parent().rset_config(property_name, multiplayer.RPC_MODE_MASTER)


func synchronize_position_reliable(position : Vector2):
	get_parent().rset("position", position)


func synchronize_position_unreliable(position : Vector2):
	get_parent().rset_unreliable("position", position)


func synchronize_rotation_reliable(rotation : float):
	get_parent().rset("rotation", rotation)


func synchronize_rotation_unreliable(rotation : float):
	get_parent().rset_unreliable("rotation", rotation)


func synchronize_scale_reliable(scale : Vector3):
	get_parent().rset("scale", scale)


func synchronize_scale_unreliable(scale : float):
	get_parent().rset_unreliable("scale", scale)


func synchronize_property_reliable(property_name : String, value):
	get_parent().rset_reliable(property_name, value)


func synchronize_property_unreliable(property_name : String, value):
	get_parent().rset_unreliable(property_name, value)


func synchronize_function(function_name : String):
	if is_in_multiplayer:
		get_parent().rpc(function_name)
	else:
		get_parent().call(function_name)
