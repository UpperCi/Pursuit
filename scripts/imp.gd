extends "res://scripts/entity.gd"

onready var spr = $Sprite
onready var anim = $AnimationPlayer

func _ready():
	anim.play("Idle")
	hp = 2
	max_hp = 2
	fire_res = true

func die():
	SFX.play_random("skull_dies", 4)
	world.delete_entity(self)

func take_turn():
	var line_of_sight = world.line_of_sight(map_pos, p_pos)
	var near = (p_pos - map_pos).length() < 2
	update_aggro(line_of_sight or near)
	if turn % 2 == 0 or not aggro:
		$AnimationPlayer.play("Idle")
	else:
		$AnimationPlayer.play("Attack")
	if aggro:
		if turn % 2 == 0:
			for d in world.DIRS:
				var cell = world.get_cell(map_pos + d)
				if (map_pos + d == p_pos or \
				(cell.valid_move and map_pos + d * 2 == p_pos)):
					world.player.hp -= 1
					VFX.create("Fireball", map_pos, p_pos, world)
					return true
			
			var path = world.find_path(map_pos, player_last_pos)
			var dir = map_pos - p_pos
			flip_spr(dir.x, spr)
			move_self(path[len(path) - 1])
			
			line_of_sight = line_of_sight or world.line_of_sight(map_pos, p_pos)
			aggro = line_of_sight or map_pos != player_last_pos
	elif map_pos != start_pos:
		if turn % 2 == 0:
			var path = world.find_path(map_pos, start_pos)
			move_self(path[len(path) - 1])
			
	update_aggro(line_of_sight)
	return true
