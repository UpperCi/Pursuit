extends Node2D

enum ITEM_TYPES {
	PICKUP,
	EXIT,
	CHEST,
	HEART
}

onready var world = get_parent().get_parent()
export var start_pos: Vector2 = Vector2.ZERO
export (ITEM_TYPES) var type

var is_open = false

var map_pos = Vector2.ZERO setget set_map_pos

func _ready():
	set_map_pos(start_pos)

func open():
	$Exit.texture = load("res://assets/ladder.png")
	$CPUParticles2D.emitting = true
	is_open = true

func set_map_pos(v):
	map_pos = v
	position = map_pos * 16 + Vector2(8, 8)
