extends KinematicBody2D



class_name Ball

var reset_ball := false
onready var synchronization_component := (
	$Node2DSynchronizationComponent as Node2DSynchronizationComponent
)

export var speed = 300
export var direction := Vector2(1, -1)

const normal_hit_register_threshold = 0.5
var start_position : Vector2

func _ready():
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


remotesync func synchronize_direction(position : Vector2, direction : Vector2):
	self.direction = direction
	self.position = position


func reset():
	position = start_position
	if is_network_master():
		rpc("synchronize_direction", position, direction)