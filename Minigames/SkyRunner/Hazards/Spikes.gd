extends Area2D


func _ready():
	pass # Replace with function body.


func _on_Spikes_body_entered(body : Player):
	if body == null:
		return
	
	body.die()
