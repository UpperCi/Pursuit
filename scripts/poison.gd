extends "res://scripts/spell.gd"

func start():
	COOLDOWN = 4

func use(start_pos: Vector2, dir: Vector2):
	var valid = false
	for i in [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT,Vector2.ZERO]:
		var current_pos = start_pos + dir + i
		var cell = world.get_cell(current_pos)
		if cell.entity and cell.entity != player:
			cell.entity.hp -= 1
			SFX.play_random("spell_cast_poison", 4)
			VFX.create("Poison", start_pos, start_pos + dir, world)
			valid = true
	
	return valid
