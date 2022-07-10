extends Node2D

export var img: Texture
export (String, FILE) var scene

onready var player = get_parent()
onready var world = player.get_parent().get_parent()

func start():
	pass

func use(start_pos: Vector2, dir: Vector2):
	return false
