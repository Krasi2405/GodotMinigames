extends Area2D



func _on_VictoryArea_body_entered(body : Player):
	if body == null:
		return

	body.win()