extends "res://scripts/entity.gd"

onready var spr = $Sprite
onready var anim = $AnimationPlayer

func _ready():
	anim.play("Idle")
	hp = 3
	max_hp = 3
	fire_res = true

func die():
	SFX.play_random("skull_dies", 4)
	world.delete_entity(self)

func take_turn():
	var valid_turn = (turn % 3) != 0
	var line_of_sight = world.line_of_sight(map_pos, p_pos)
	update_aggro(line_of_sight)
	if turn % 3 == 2 or not aggro:
		$AnimationPlayer.play("Idle")
	else:
		$AnimationPlayer.play("Attack")
	if aggro:
		if valid_turn:
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
	elif map_pos != start_pos:
		if turn % 2 == 0:
			var path = world.find_path(map_pos, start_pos)
			move_self(path[len(path) - 1])
			
	update_aggro(line_of_sight)
	return true
