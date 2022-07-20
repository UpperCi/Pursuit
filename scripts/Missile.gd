extends "res://scripts/spell.gd"

func start():
	COOLDOWN = 8

func use(start_pos: Vector2, dir: Vector2):
	var shortest = 5
	var shortest_e = null
	for e in world.entities:
		if not e.is_player:
			var path = world.find_path(start_pos, e.map_pos)
			if len(path) < shortest:
				shortest = len(path)
				shortest_e = e
	if shortest >= 5:
		return false
	
	shortest_e.hp -= 1
	SFX.play_random("spell_cast_missile_1", 2)
	SFX.play_random("spell_cast_missile_2", 2)
	VFX.create("Missile", start_pos, shortest_e.map_pos, world)
	return true
