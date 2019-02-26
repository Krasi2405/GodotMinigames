extends  KinematicBody2D

var log_rotate = true
var is_rotate_direction_positive = true

export var rotation_speed = 0.06
export var movement_speed = 5000

func _ready():
	pass
	
func press_action():
	log_rotate = false


func hold_action(delta):
	log_rotate = false;
	move_and_slide(-get_global_transform().y.normalized() * movement_speed * delta)


func release_action():
	log_rotate = true
	is_rotate_direction_positive = not is_rotate_direction_positive


func _process(delta):
	if log_rotate:
		if is_rotate_direction_positive:
			rotation = self.rotation + deg2rad(90 * rotation_speed * delta)
		else:
			rotation = self.rotation - deg2rad(90 * rotation_speed * delta)


func _on_HitArea_body_entered(body):
	if body == self:
		return;
	
	
	# TODO: ONLY die when lives <= 0. else respawn at begin location.
	if body.name == "Player":
		destroy()
		body.destroy()
		
func destroy():
	get_parent().die()