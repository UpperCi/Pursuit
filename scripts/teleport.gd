extends "res://scripts/spell.gd"

func start():
	COOLDOWN = 5

func use(start_pos: Vector2, dir: Vector2):
	var longest = 0
	var longest_e = null
	for e in world.entities:
		if not e.is_player:
			var path = world.find_path(start_pos, e.map_pos)
			if len(path) > longest and len(path) < 5:
				longest = len(path)
				longest_e = e
	if longest <= 0:
		return false
	
	var start_map_pos = world.player.map_pos
	var longest_map_pos = longest_e.map_pos
	world.player.move_self(Vector2(-100, -100))
	longest_e.move_self(start_map_pos)
	world.player.move_self(longest_map_pos)
	SFX.play_random("spell_cast_missile_1", 2)
	SFX.play_random("spell_cast_missile_2", 2)
	return true
