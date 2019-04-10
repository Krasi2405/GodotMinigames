extends Camera2D


onready var players : Array
onready var camera_width : float = get_viewport().get_visible_rect().size.x

var max_x := 0
var max_player : Player = null

func _ready():
	print("camera width: ", camera_width)
	for player_controller in Global.get_minigame_manager().get_player_nodes():
		var player : Player = (player_controller as PlayerController).get_player_child()
		players.append(player)
	
	limit_right = $"../VictoryArea".position.x + 100

func _process(delta):
	for player in players:
		if !weakref(player).get_ref():
			players.erase(player)
			continue

		if player.position.x > max_x:
			max_player = player
			max_x = player.position.x
	
	position = Vector2(max_x, position.y)