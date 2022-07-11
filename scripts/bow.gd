extends "res://scripts/weapon.gd"

var is_spun = false

func use(start_pos: Vector2, dir: Vector2):
	if not is_spun:
		is_spun = true
		img = load("res://assets/bow_spun.png")
		SFX.play_random("bow_load", 4)
		player.update_item_ui()
		return true
	else:
		for i in range(3):
			var new_pos = start_pos + dir * i + dir
			var cell = world.get_cell(new_pos)
			if cell.entity:
				cell.entity.hp -= 1
				SFX.play_random("bow_attack", 4)
				VFX.create("Arrow", start_pos, new_pos, world)
				is_spun = false
				img = load("res://assets/bow.png")
				player.update_item_ui()
				return true
	return false
