extends Node2D


var parent
var minX
var minY
var maxX
var maxY


func _ready():
	parent = get_parent()
	
	var viewport_size = get_viewport().get_visible_rect()
	minX = viewport_size.position.x
	minY = viewport_size.position.y
	
	maxX = viewport_size.end.x
	maxY = viewport_size.end.y


func _process(delta):
	screenwrap_parent_position()


func screenwrap_parent_position():
	var pos = parent.position
	
	if pos.x < minX:
		pos.x = maxX
		
	if pos.x > maxX:
		pos.x = minX
	
	if pos.y < minY:
		pos.y = maxY
	
	if pos.y > maxY:
		pos.y = minY
		
	parent.position = pos
