extends  KinematicBody2D

var log_rotate = true
var is_rotate_direction_positive = true

export var rotation_speed = 0.06
export var movement_speed = 5000
export var lives = 3
var invulnereble = false
var start_position

func _ready():
	start_position = self.get_global_transform().get_origin()
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
	if invulnereble:
		return;
		
	if body == self:
		return;
	
	lives-=1
	self.position = start_position	
	
	# TODO: ONLY die when lives <= 0. else respawn at begin location.
	if lives == 0:
		destroy()
		
func destroy():
	get_parent().die()