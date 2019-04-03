"""
Base Player class.
Used in order to make sure project hierarchy is kept in all minigames
and for typed scripting support.
"""

extends KinematicBody2D

class_name Player


# assert(false) is a way of making sure it is inherited by player if called
func press_action():
	assert(false)


func hold_action(delta : float):
	assert(false)


func release_action():
	assert(false)