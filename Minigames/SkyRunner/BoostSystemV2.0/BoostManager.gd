tool
extends Node2D


const BOOST_SIZE = 64


export(String, FILE, GLOBAL, "*.gd") var effect_script setget set_effect_script
export(String, FILE, GLOBAL) var boost_graphic setget set_boost_graphic

var has_been_collected = false

func _ready():
	if Engine.is_editor_hint():
		return
	assert(effect_script != "")
	assert(boost_graphic != "")
	

func set_effect_script(effect_script_path : String) -> void:
	if effect_script_path == "":
		clear_script()
	else:
		var script := load(effect_script_path) as Script
		if script == null:
			clear_script()
			return

		var boost_effect_node := ($BoostEffect as Node2D)
		boost_effect_node.set_script(script)
		if boost_effect_node.has_method("apply_effect"):
			effect_script = effect_script_path
		else:
			clear_script()


func clear_script():
	($BoostEffect as Node2D).set_script(null)
	effect_script = ""


func set_boost_graphic(path : String) -> void:
	if path == "":
		reset_graphics()
		return
		
	var instance : Resource = load(path)
	if instance == null:
		reset_graphics()
		return

	if instance is SpriteFrames:
		var size := (instance as SpriteFrames).get_frame("default", 0).get_size()
		$Animation.scale = Vector2(BOOST_SIZE / size.x, BOOST_SIZE / size.y)
		($Animation as AnimatedSprite).set_sprite_frames(instance)
		($Icon as TextureRect).set_texture(null)
		boost_graphic = path
	elif instance is Texture:
		var texture := (instance as Texture)
		($Icon as TextureRect).set_texture(texture)
		($Animation as AnimatedSprite).set_sprite_frames(null)
		boost_graphic = path
	else:
		print("Invalid graphic type for boost")
		reset_graphics()


func reset_graphics() -> void:
	$Icon.texture = null
	($Animation as AnimatedSprite).set_sprite_frames(null)
	boost_graphic = ""


func _on_Area2D_body_entered(body : Player):
	if body == null || has_been_collected:
		return
	
	has_been_collected = true
	$BoostEffect.apply_effect(body)
