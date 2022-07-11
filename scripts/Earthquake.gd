extends "res://scripts/spell.gd"

func start():
	COOLDOWN = 6

func use(start_pos: Vector2, dir: Vector2):
	var valid = false
	for d in [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT]:
		var current_pos = start_pos + d
		var cell = world.get_cell(current_pos)
		if cell.entity and cell.entity != player:
			cell.entity.hp -= 1
			cell.entity.move_self(start_pos + d * 2)
			SFX.play_random("spell_cast_earthquake", 4)
			VFX.create("Earthquake", start_pos, start_pos, world)
			valid = true
	
	return valid
