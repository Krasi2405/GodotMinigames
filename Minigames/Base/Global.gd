"""
Keep reference to all global data that is always in use.
"""


extends Node2D


var minigame_manager : MinigameManager
var input_manager : InputManager

func get_minigame_manager() -> MinigameManager:
	return minigame_manager


func set_minigame_manager(minigame_manager : MinigameManager) -> void:
	self.minigame_manager = minigame_manager


func get_input_manager() -> InputManager:
	return input_manager
	
func set_input_manager(input_manager : InputManager) -> void:
	self.input_manager = input_manager


	

