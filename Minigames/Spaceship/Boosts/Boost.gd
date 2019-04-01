extends Node2D



func _ready():
	# If you get assertion failed create BoostController with effect(player_ship) function
	assert($BoostController != null)
	assert($BoostController.has_method("apply_effect"))
	$DestroyTime.start()
	
	


func _on_Boost_body_entered(body):
	if(body.name == "Player"):
		$BoostController.apply_effect(body)
		queue_free()
	
	

func _on_DestroyTime_timeout():
	queue_free()
