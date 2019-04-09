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
	motion.y += GRAVITY * delta;

	if motion.y >= terminal_velocity:
		motion.y = terminal_velocity
	
	if(is_jumbing): 
		motion.y = jumping_height
		is_jumbing = false
	
	if player.is_on_ceiling():
		motion.y = 0
	"""
	var snap := Vector2(0, 1)
	if motion.y > 0:
		snap.y = 0
	"""
	move_and_slide(motion, UP)

func press_action():
	
	if player.is_on_floor():
		is_jumbing = true