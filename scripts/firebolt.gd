extends "res://scripts/spell.gd"

func start():
	COOLDOWN = 4

func use(start_pos: Vector2, dir: Vector2):
	for i in range(4):
		var current_pos = start_pos + dir * i + dir
		var cell = world.get_cell(current_pos)
		if cell.tile != -1:
			return false
		if cell.entity:
			cell.entity.hp -= 1
			SFX.play_random("spell_cast_fire", 6)
			VFX.create("Fireball", start_pos, current_pos, world)
			return true
	return false
