extends "res://scripts/entity.gd"

enum DIRS {
	UP, DOWN, LEFT, RIGHT
}

export var offset = 0
export (DIRS) var facing
export var min_room = 0

onready var spr = $Sprite
onready var dir = [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT][facing]

func _ready():
	fire_res = true
	if Universe.room_num < min_room:
		world.connect("ready", self, "die")
	hp = 20
	max_hp = 20
	flip_spr(-dir.x, spr)
	if turn % 3 == (offset - 1) % 3 or (turn % 3 == 2 and offset == 0):
		spr.frame = 1


func die():
	world.delete_entity(self)

func take_turn():
	if turn % 3 == (offset - 1) % 3 or (turn % 3 == 2 and offset == 0):
		spr.frame = 1
	else:
		spr.frame = 0
	if turn % 3 == offset:
		var end = map_pos
		for i in range(14):
			var pos = map_pos + i * dir + dir
			var cell = world.get_cell(pos)
			if cell.entity:
				if cell.entity.fire_res:
					break
				cell.entity.hp -= 1
				end = pos
				break
			elif not cell.valid_move:
				break
			end = pos
		VFX.create("Fireball", map_pos, end + dir * 0.1, world)
	return true
