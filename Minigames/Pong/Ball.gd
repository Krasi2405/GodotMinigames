extends KinematicBody2D



class_name Ball

var reset_ball := false
onready var synchronization_component := (
	$Node2DSynchronizationComponent as Node2DSynchronizationComponent
)

export var start_speed = 300
export var speed_increase_per_second = 300
export var direction := Vector2(1, -1)

var speed

const normal_hit_register_threshold = 0.5
var start_position : Vector2

func _ready():
	speed = start_speed
	start_position = position


func _process(delta):
	var collision := move_and_collide(direction * speed * delta)
	if collision:
		var body := collision.collider
		var normal = collision.normal
		
		if abs(normal.y) > normal_hit_register_threshold:
			direction.y *= -1
		
		if abs(normal.x) > normal_hit_register_threshold:
			direction.x *= -1
		
		if is_network_master():
			rpc("synchronize_direction", position, direction)
	
	speed += speed_increase_per_second * delta / 60
	print(speed)


remotesync func synchronize_direction(position : Vector2, direction : Vector2):
	self.direction = direction
	self.position = position


func reset():
	speed = start_speed
	position = start_position
	direction *= -1
	if is_network_master():
		rpc("synchronize_direction", position, direction)