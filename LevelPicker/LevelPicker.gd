"""
Load all the minigames.
"""


extends Control

class_name LevelPicker


signal choose_level(level)

export(String, DIR) var search_dir : String
const LEVEL_CHOICE_PREFAB_PATH : String = "res://LevelPicker/LevelChoice.tscn"

var level_choice_prefab : Resource

func _enter_tree():
	level_choice_prefab = load(LEVEL_CHOICE_PREFAB_PATH)
	
	var filenames := get_dir_filenames(search_dir)
	for file_array_item in filenames:
		var filepath : String = file_array_item
		var extension : String = filepath.get_extension()
		if extension == "tscn":
			var level_choice := (level_choice_prefab.instance() as LevelChoice)
			level_choice.set_level(filepath)
			level_choice.connect("chosen", self, "choose_level")
			
			var icon_path := filepath.get_basename() + ".png"
			if File.new().file_exists(icon_path):
				level_choice.set_icon(icon_path)
			else:
				print("Icon not found for %s! Using default icon." % filepath)
			
			add_child(level_choice)


func choose_level(level : String):
	if get_signal_connection_list("choose_level").size() == 0:
		get_tree().change_scene(level)
	else:
		emit_signal("choose_level", level)


func get_dir_filenames(var search_dir : String) -> Array:
	var files := []
	
	var dir := Directory.new()
	dir.open(search_dir)
	dir.list_dir_begin()
	while true:
		var file_name : String = dir.get_next()
		
		# Gives empty file_name at end of dir iterator.
		if file_name == "":
			break
		
		if dir.current_is_dir():
			continue
		
		files.append(search_dir + "/" + file_name)
		
	return files
