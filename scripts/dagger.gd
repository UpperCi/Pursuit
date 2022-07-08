extends "res://scripts/weapon.gd"

func use(start_pos: Vector2, dir: Vector2):
	var new_pos = start_pos + dir
	var cell = world.get_cell(new_pos)
	if cell.entity:
		cell.entity.hp -= 1
		return true
	return false
