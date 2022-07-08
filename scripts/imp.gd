extends "res://scripts/entity.gd"

func take_turn():
	if turn % 2 == 0:
		return true
	var p_pos = world.player.map_pos
	if (map_pos - p_pos).length() > 1:
		var path = world.find_path(map_pos, p_pos)
		move_self(path[len(path) - 1])
	else:
		world.player.hp -= 1
	return true
