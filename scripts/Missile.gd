extends "res://scripts/spell.gd"

func start():
	COOLDOWN = 8

func use(start_pos: Vector2, dir: Vector2):
	for e in world.entities:
		if not e.is_player:
			var path = world.find_path(start_pos, e.map_pos)
			if len(path) < 5:
				e.hp -= 1
				SFX.play_random("spell_cast_missile_1", 2)
				SFX.play_random("spell_cast_missile_2", 2)
				VFX.create("Missile", start_pos, e.map_pos, world)
				return true
	return false
