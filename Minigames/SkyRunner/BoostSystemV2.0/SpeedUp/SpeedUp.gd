extends Node2D

func _ready():
	print("Ready speed up boost!")

func apply_effect(player : Player) -> void:
	print("Applied speed boost on ", player)