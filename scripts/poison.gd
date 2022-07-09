extends "res://scripts/spell.gd"

func _ready():
	COOLDOWN = 4

func use(start_pos: Vector2, dir: Vector2):
	var valid = false
	for i in world.DIRS:
		var current_pos = start_pos + dir + i
		var cell = world.get_cell(current_pos)
		if cell.entity and cell.entity != player:
			cell.entity.hp -= 1
			SFX.play_random("spell_cast_poison", 4)
			valid = true
	
	return valid
