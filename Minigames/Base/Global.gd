"""
Keep reference to all global data that is always in use.
"""


extends Node2D


var minigame_manager : MinigameManager
var input_manager : InputManager
var lobby : Lobby
var camera : Camera



func get_minigame_manager() -> MinigameManager:
	return minigame_manager


func set_minigame_manager(minigame_manager : MinigameManager) -> void:
	self.minigame_manager = minigame_manager
	camera = (minigame_manager as Node2D).get_node("Camera")


func get_input_manager() -> InputManager:
	return input_manager


func set_input_manager(input_manager : InputManager) -> void:
	self.input_manager = input_manager


func set_lobby(lobby : Lobby) -> void:
	self.lobby = lobby


func get_lobby() -> Lobby:
	return lobby;

