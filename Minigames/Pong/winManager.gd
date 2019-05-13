extends Node2D

onready var RIGHT_COLLIDER = $"RightSideCollision"
onready var LEFT_COLLIDER = $"LeftSideCollision"

var leftTeamLives = 3
var rightTeamLives = 3

func _on_Ball_body_entered(body):
	print(body)

	if(body == LEFT_COLLIDER):
		print("Left collider")
		leftTeamLives-=1

	if(body == RIGHT_COLLIDER):
		print("right collider")
		rightTeamLives-=1
	if(leftTeamLives < 1):
		var timer : SceneTreeTimer = get_tree().create_timer(3)
		timer.connect("timeout", self, "reset")
		print("Right team wins!")
		
	if(rightTeamLives < 1):
		print("Left team wins!")

func reset():
	get_tree().change_scene("res://MainMenu.tscn")