extends Player

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
	if texture != null:
		print("Add texture")
		$Sprite.texture = texture
	start_position = self.get_global_transform().get_origin()


func press_action():
	log_rotate = false


func press_action_synchronize():
	print("press action synchronize " + str(get_parent().player_id))
	synchronize_movement()


func hold_action(delta):
	log_rotate = false;
	var collision = move_and_collide(
		-get_global_transform().y.normalized() * movement_speed * delta
	)

	if collision != null:
		var body = collision.collider
		if is_hit:
			return;
		
		print("player hit ", body)
		var should_collide = false
		for i in range(20):
			var bit_mask : bool = get_collision_mask_bit(i)
			var bit_layer : bool = body.get_collision_layer_bit(i)
			if bit_mask and bit_layer:
				should_collide = true
				break
		
		if should_collide:
			if not invulnereble:
				hit()
			if body.has_method("hit"):
				body.hit()


func hold_action_synchronize():
	pass


func release_action():
	log_rotate = true
	is_rotate_direction_positive = not is_rotate_direction_positive


func release_action_synchronize():
	pass


func _process(delta):
	if is_hit:
		_take_damage()
		is_hit = false
	
	if log_rotate:
		if is_rotate_direction_positive:
			rotation = self.rotation + deg2rad(90 * rotation_speed * delta)
		else:
			rotation = self.rotation - deg2rad(90 * rotation_speed * delta)
	

func hit():
	if invulnereble:
		return
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
	
	if Global.lobby:
		rpc("synchronize_movement")


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
	print("Spaceship " + str(get_parent().player_id) + " is dead!")
	get_parent().die()


func synchronize_movement():
	rpc("synchronize_movement_rpc", position, rotation)


puppet func synchronize_movement_rpc(position : Vector2, rotation : float):
	self.position = position
	self.rotation = rotation
