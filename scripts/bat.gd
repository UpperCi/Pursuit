extends "res://scripts/entity.gd"

onready var spr = $Sprite
onready var anim = $AnimationPlayer

func _ready():
	anim.play("Idle")
	hp = 2
	max_hp = 2

func die():
	SFX.play_random("bat_dies", 4)
	world.delete_entity(self)

func take_turn():
	var line_of_sight = world.line_of_sight(map_pos, p_pos)
	update_aggro(line_of_sight)
	if line_of_sight:
		aggro = true
		player_last_pos = p_pos
	if turn % 2 == 1:
		anim.play("Attack")
	else:
		anim.play("Idle")
	if aggro:
		if turn % 2 == 0:
			if in_adjacent():
				world.player.hp -= 1
				VFX.create("Slash", map_pos, p_pos, world)
				return true
			var path = world.find_path(map_pos, player_last_pos)
			var dir = map_pos - p_pos
			flip_spr(dir.x, spr)
			move_self(path[len(path) - 1])
			
			line_of_sight = line_of_sight or world.line_of_sight(map_pos, p_pos)
			aggro = line_of_sight or map_pos != player_last_pos
	else:
		if turn % 2 == 0:
			var valid_dirs = []
			for d in world.DIRS:
				var cell = world.get_cell(map_pos + d)
				if cell.valid_move:
					valid_dirs.push_back(d)
			if len(valid_dirs) > 0:
				var dir = valid_dirs[randi() % len(valid_dirs)]
				flip_spr(-dir.x, spr)
				move_self(map_pos + dir)
	return true
