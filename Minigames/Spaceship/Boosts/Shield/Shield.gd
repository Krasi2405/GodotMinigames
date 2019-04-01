extends Node2D

func _ready():
	$Timer.start()

func _on_Timer_timeout():
	get_parent().invulnereble = false
	queue_free()
