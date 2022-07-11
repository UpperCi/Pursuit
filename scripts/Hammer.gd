extends "res://scripts/weapon.gd"

func use(start_pos: Vector2, dir: Vector2):
	var new_pos = start_pos + dir
	var cell = world.get_cell(new_pos)
	if cell.entity:
		cell.entity.hp -= 1
		cell.entity.move_self(new_pos + dir)
		VFX.create("Slash", start_pos, new_pos, world)
		SFX.play_random("knife_hit", 4)
		return true
	return false
