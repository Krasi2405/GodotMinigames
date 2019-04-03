"""
Placeholder for showing the winners.
"""

extends HBoxContainer

class_name WinText

func parse_winners(player_id_win_order : Array):
	($WinText as RichTextLabel).add_text("Player %d won!\n" % player_id_win_order[0])
	for i in range(1, player_id_win_order.size()):
		($WinText as RichTextLabel).add_text(
				"Player %d placed at %d place\n" % [player_id_win_order[i], i + 1]
			)