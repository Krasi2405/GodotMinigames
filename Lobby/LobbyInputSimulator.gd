extends Control

export var desired_player_count := 2
export var level_to_load = "res://Minigames/Pong/Pong.tscn"

var is_loading := false
var is_host := false
var lock_file : File
const file_name := "user://lobby_lock"

func _ready():
	# Add delay to action
	var timer := get_tree().create_timer(0.033)
	timer.connect("timeout", self, "simulate")


func simulate():
	lock_file = File.new()
	lock_file.open(file_name, File.WRITE)
	if lock_file.is_open():
		is_host = true
		_simulate_host_click()
	else:
		_simulate_join_click()


func _process(delta):
	if is_host and Global.lobby.user_count >= desired_player_count and not is_loading:
		var load_level_timer := get_tree().create_timer(0.033)
		load_level_timer.connect("timeout", self, "_simulate_load_level")
		is_loading = true


func _simulate_host_click():
	$"../HostBTN".emit_signal("button_down")


func _simulate_load_level():
	Global.lobby.load_level_signal(level_to_load)


func _simulate_join_click():
	$"../JoinBTN".emit_signal("button_down")


func _exit_tree():
	if is_host:
		lock_file.close()