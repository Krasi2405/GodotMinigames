Minigame Manager
================

`Source <https://github.com/Krasi2405/GodotMinigames/blob/master/Minigames/Base/MinigameManager.gd>`_


| Handles sending input to player controlers
| Handles player win order and win behaviour
| Instantiation logic for everything	


In the inspector you can set the player count of the game and the signals the game is going to use.

.. code::

	export var player_count := 4

	export var use_press_signal := true
	export var use_hold_signal := true
	export var use_release_signal := true


Functions:
----------


| Tell the minigame manager to win using this win order.
| Internally used when using manager functions for keeping track of rankings.
| But also offers freedom to externally keep track of player rankings and give external win list.

.. code::

	func win(player_id_win_order) -> void:




Signal a player has died.

.. code::
	
	func remove_player(player_id : int) -> void:




Get list of active PlayerControllers.

.. code::
	
	func get_player_nodes() -> Array:




Get number of active players

.. code::

	func get_player_count() -> int:







