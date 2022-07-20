extends "res://scripts/weapon.gd"

func start_room():
	SFX.play_random("pickUp_heart", 6)
	world.player.hp += 1
	world.player.weapon = load("res://scenes/items/Nothing.tscn").instance()
	VFX.create("Open", world.player.start_pos, world.player.start_pos, world)
	world.player.update_items()

func use(start_pos: Vector2, dir: Vector2):
	return false
