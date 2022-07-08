extends "res://scripts/spell.gd"

func _ready():
	COOLDOWN = 4

func use(start_pos: Vector2, dir: Vector2):
	for i in range(3):
		var current_pos = start_pos + dir * i + dir
		var cell = world.get_cell(current_pos)
		if cell.tile != -1:
			return false
		if cell.entity:
			cell.entity.hp -= 1
			return true
	return false
