extends Player

# Declare member variables here. Examples:
# var a = 2
export var movement_speed = 50
export var jumping_height = -100

export var GRAVITY = 20
var is_jumbing = false;
var motion := Vector2()

var UP = Vector2(0, -1)

export var terminal_velocity := 1000

var player := (self as KinematicBody2D)

# Called when the node enters the scene tree for the first time.
func _ready():
	motion.x = movement_speed
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.lobby and is_network_master():
		if not player.is_on_floor():
			motion.y += GRAVITY * delta;
	
		if motion.y >= terminal_velocity:
			motion.y = terminal_velocity
		
		
		
		if(is_jumbing): 
			motion.y = jumping_height
			is_jumbing = false
	
	
		if player.is_on_ceiling() and not player.is_on_floor():
			motion.y = 0
	
	move_and_slide(motion, UP, false, 4, deg2rad(80))
	
	if is_network_master() and !$VisibilityNotifier2D.is_on_screen():
		commit_neck_rope()
	
	if Global.lobby and is_network_master():
		rpc_unreliable("synchronize_synchronization", position, motion)
		


puppet func synchronize_synchronization(position : Vector2, motion : Vector2):
	self.position = position
	self.motion = motion


func press_action():
	if player.is_on_floor():
		is_jumbing = true
		

func press_action_synchronize():
	pass


func die():
	commit_neck_rope()


func commit_neck_rope():
	get_parent().die()


func win():
	$CollisionPolygon2D.disabled = true
	get_parent().win()