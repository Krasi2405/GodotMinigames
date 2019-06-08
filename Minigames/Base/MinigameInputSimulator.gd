extends Node2D

var minigame_manager : MinigameManager

func _ready():
	minigame_manager = Global.get_minigame_manager()


func _process(delta):
	if Input.is_action_just_pressed("1"):
		simulate_win(0)
	
	if Input.is_action_just_pressed("2"):
		simulate_win(1)
		
	if Input.is_action_just_pressed("3"):
		simulate_win(2)
		
	if Input.is_action_just_pressed("4"):
		simulate_win(3)


func simulate_win(player_id : int):
	print("simulate win for player " + str(player_id))
	minigame_manager.add_winner(player_id)