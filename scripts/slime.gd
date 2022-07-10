extends "res://scripts/entity.gd"

onready var spr = $Sprite
onready var anim = $AnimationPlayer

func _ready():
	anim.play("Idle")

func die():
	SFX.play_random("slime_dies", 4)
	world.delete_entity(self)

func take_turn():
	var line_of_sight = world.line_of_sight(map_pos, p_pos)
	update_aggro(line_of_sight)
	if line_of_sight:
		aggro = true
		player_last_pos = p_pos
	if aggro:
		if turn % 3 != 0:
			return true
		anim.play("Jump")
		for i in range(2):
			var path = world.find_path(map_pos, player_last_pos)
			var path_player = world.find_path(map_pos, p_pos)
			if len(path_player) <= 1:
				world.player.hp -= 1
				VFX.create("Slime", map_pos, p_pos, world)
				return true
			var dir = map_pos - p_pos
			flip_spr(dir.x, spr)
			move_self(path[len(path) - 1])
			
			line_of_sight = line_of_sight or world.line_of_sight(map_pos, p_pos)
			aggro = line_of_sight or map_pos != player_last_pos
	else:
		if turn % 3 != 0:
			return true
		var valid_dirs = []
		for d in world.DIRS:
			var cell = world.get_cell(map_pos + d * 2)
			if cell.valid_move and world.get_cell(map_pos + d).valid_move:
				valid_dirs.push_back(d * 2)
		if len(valid_dirs) == 0:
			for d in world.DIRS:
				var cell = world.get_cell(map_pos + d)
				if cell.valid_move:
					valid_dirs.push_back(d)
		
		if len(valid_dirs) > 0:
			var dir = valid_dirs[randi() % len(valid_dirs)]
			flip_spr(-dir.x, spr)
			move_self(map_pos + dir)
	return true
