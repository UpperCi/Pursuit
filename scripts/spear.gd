extends "res://scripts/weapon.gd"

func use(start_pos: Vector2, dir: Vector2):
	var new_pos = start_pos + dir * 2
	var cell = world.get_cell(new_pos)
	if cell.entity:
		cell.entity.hp -= 1
		VFX.create("Poke", start_pos, new_pos, world)
		SFX.play_random("knife_hit", 4)
		return true
	return false
