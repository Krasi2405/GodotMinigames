extends Node2D

var leftTeamLives = 3
var rightTeamLives = 3


func reset():
	print("Reset")
	get_tree().change_scene("res://MainMenu.tscn")


func _on_LeftSideCollision_body_entered(body : Ball):
	print(body)
	if(body != null):
		body.reset()
		print("Left collider")
		leftTeamLives-=1
		if(leftTeamLives < 1):
			var timer : SceneTreeTimer = get_tree().create_timer(3)
			timer.connect("timeout", self, "reset")
			print("Right team wins!")
	
			
func _on_RightSideCollision_body_entered(body : Ball):
	if(body != null):
		body.reset()
		print("right collider")
		rightTeamLives-=1
		if(rightTeamLives < 1):
			var timer : SceneTreeTimer = get_tree().create_timer(3)
			timer.connect("timeout", self, "reset")
			print("Left team wins!")
