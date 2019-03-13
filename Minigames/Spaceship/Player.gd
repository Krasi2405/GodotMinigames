extends  KinematicBody2D

var log_rotate = true
var is_rotate_direction_positive = true

export var rotation_speed = 0.06
export var movement_speed = 5000
export var lives = 3
export(Texture) var texture

var is_hit = false
var invulnereble = false
var is_blinging = false
var start_position

func _ready():
	$Sprite.texture = texture
	start_position = self.get_global_transform().get_origin()


func press_action():
	log_rotate = false


func hold_action(delta):
	log_rotate = false;
	move_and_slide(-get_global_transform().y.normalized() * movement_speed * delta)
	


func release_action():
	log_rotate = true
	is_rotate_direction_positive = not is_rotate_direction_positive


func _process(delta):
	if is_hit:
		_take_damage()
		is_hit = false
	
	if log_rotate:
		if is_rotate_direction_positive:
			rotation = self.rotation + deg2rad(90 * rotation_speed * delta)
		else:
			rotation = self.rotation - deg2rad(90 * rotation_speed * delta)


func _on_HitArea_body_entered(body):
	if invulnereble or is_hit:
		return;
		
	if body == self:
		return;
	
	if body.has_method("hit"):
		body.hit()
	hit()
	

func hit():
	is_hit = true


func _take_damage():
	if invulnereble:
		return

	lives-=1
	if lives == 0:
		_destroy()
	else:
		_respown()

	
func _respown():
	invulnereble = true
	$InvulnerebleTime.start()
	
	self.position = start_position
	
	is_blinging = true
	_bling()
	$BlingTimer.start()


func _on_InvulnerebleTime_timeout():
	invulnereble = false
	is_blinging = false
	$Sprite.modulate.a = 1
	
	
func _bling():
	if $Sprite.modulate.a == 1:
		$Sprite.modulate.a = 0.4
	else:
		$Sprite.modulate.a = 1


func _on_BlingTimer_timeout():
	if is_blinging:
		_bling()
		$BlingTimer.start()
		
func _destroy():
	get_parent().die()


