extends Node2D

export var start_pos: Vector2 = Vector2.ZERO

var map_pos = Vector2.ZERO setget set_map_pos
var is_player = false
var hp = 3 setget set_hp
var turn = 0
var tween: Tween

onready var world = get_parent().get_parent()
onready var map_item_scene = preload("res://scenes/Item.tscn")

func _ready():
	self.map_pos = start_pos
	tween = Tween.new()
	add_child(tween)

func move_self(new_pos: Vector2):
	return world.move_entity(self, new_pos)

func take_turn():
	return true

func drop_item(pos: Vector2, scene: PackedScene, img: Texture):
	var map_item_node = map_item_scene.instance()
	map_item_node.start_pos = pos
	map_item_node.img = img
	map_item_node.target_weapon = scene
	world.create_item(map_item_node)
	
func start_turn():
	pass

func end_turn():
	pass

func set_map_pos(v):
	map_pos = v
	#position = map_pos * 16 + Vector2(8, 8)
	if tween:
		tween.interpolate_property(self, "position", position,
		map_pos * 16 + Vector2(8, 8), 0.15, Tween.TRANS_QUAD,
		Tween.EASE_OUT)
		tween.start()
	else:
		position = map_pos * 16 + Vector2(8, 8)

func die():
	world.delete_entity(self)

func set_hp(v):
	if v < hp:
		tween.interpolate_property(self, "modulate", Color(10, 10, 10),
		Color(1, 1, 1), 0.25, Tween.TRANS_QUAD,
		Tween.EASE_OUT)
		tween.start()
		print("ouch!")
	elif v > hp:
		print("yay!")
	hp = v
	print(hp)
	
	if hp <= 0:
		die()
