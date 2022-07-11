extends Node2D

export var start_pos: Vector2 = Vector2.ZERO
export (Array, String) var pool = ["Imp","Slime","Bat"]
export (float) var chance = 1.0
var is_player = false

onready var world = get_parent().get_parent()

func _ready():
	world.connect("ready", self, "gen")

func gen():
	if randf() - Universe.room_num / 10 < chance:
		var enemy = pool[randi() % len(pool)]
		var enemy_scene = "res://scenes/enemies/" + enemy + ".tscn"
		var enemy_node = load(enemy_scene).instance()
		enemy_node.start_pos = start_pos
		enemy_node.map_pos = start_pos
		world.add_entity(enemy_node)
	world.delete_entity(self)
