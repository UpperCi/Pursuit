extends Node2D

enum ITEM_TYPES {
	PICKUP,
	EXIT
}

onready var world = get_parent().get_parent()
export var start_pos: Vector2 = Vector2.ZERO
export (ITEM_TYPES) var type

var map_pos = Vector2.ZERO setget set_map_pos

func _ready():
	set_map_pos(start_pos)

func set_map_pos(v):
	map_pos = v
	position = map_pos * 16 + Vector2(8, 8)
