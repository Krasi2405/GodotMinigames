extends Control

export(String, DIR) var search_dir

const LEVEL_CHOICE_PREFAB_PATH = "res://LevelPicker/LevelChoice.tscn"

func _ready():
	var filenames = get_dir_filenames(search_dir)
	for filepath in filenames:
		var extension = filepath.get_extension()
		if extension == "tscn":
			var icon_path = filepath.get_basename() + ".png"
			var level_choice = load(LEVEL_CHOICE_PREFAB_PATH).instance()
			level_choice.level = filepath
			if File.new().file_exists(icon_path):
				var texture = load(icon_path)
				level_choice.texture_normal = texture
			else:
				print("Icon not found for %s using default icon" % filepath)
			
			$HBoxContainer.add_child(level_choice)
		
		
func get_dir_filenames(var search_dir):
	var files = []
	
	var dir = Directory.new()
	dir.open(search_dir)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		
		if dir.current_is_dir():
			continue
		
		files.append(search_dir + "/" + file_name)
		
	return files
