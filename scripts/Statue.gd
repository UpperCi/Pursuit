extends "res://scripts/entity.gd"

enum DIRS {
	UP, DOWN, LEFT, RIGHT
}

export (DIRS) var facing

onready var spr = $Sprite
onready var dir = [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT][facing]

func _ready():
	hp = 20
	max_hp = 20
	flip_spr(-dir.x, spr)

func die():
	world.delete_entity(self)

func take_turn():
	if turn % 2 == 0:
		var end = map_pos
		for d in world.DIRS:
			for i in range(14):
				var pos = map_pos + i * d + d
				var cell = world.get_cell(pos)
				if cell.entity:
					cell.entity.hp -= 1
					end = pos
					break
				elif not cell.valid_move:
					break
				end = pos
		VFX.create("Fireball", map_pos, end, world)
	return true
