extends Node2D

enum RARITIES {
	COMMON,
	RARE
}

export var img: Texture
export (String, FILE) var scene
export (String) var item_name
export (String, MULTILINE) var item_desc

var rarity = RARITIES.COMMON

onready var player = get_parent()
onready var world = player.get_parent().get_parent()

func start():
	pass

func start_room():
	pass

func use(start_pos: Vector2, dir: Vector2):
	return false
