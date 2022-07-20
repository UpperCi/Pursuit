extends "res://scripts/spell.gd"

func start():
	COOLDOWN = 7

func use(start_pos: Vector2, dir: Vector2):
	world.player.shielded = true
	SFX.play_random("spell_cast_missile_1", 2)
	SFX.play_random("knife_hit", 4)
	SFX.play_random("spell_cast_fire", 6)
	VFX.create("Shield", start_pos, start_pos, world)
	return true
