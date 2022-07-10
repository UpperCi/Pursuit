extends Node2D

export var start_pos: Vector2 = Vector2.ZERO
export var is_player = false

var map_pos = Vector2.ZERO setget set_map_pos
var hp = 3 setget set_hp
var max_hp = 3
var turn = 0
var tween: Tween
var aggro = false
var p_pos = Vector2.ZERO
var player_last_pos = Vector2.ZERO

onready var world = get_parent().get_parent()
onready var map_item_scene = preload("res://scenes/Item.tscn")

func update_aggro(condition):
	if condition:
		aggro = true
		player_last_pos = p_pos

func update_aggro_end(condition):
	pass

func in_adjacent():
	for d in world.DIRS:
		var pos = map_pos + d
		if p_pos == pos:
			return true
	return false

func _ready():
	self.map_pos = start_pos
	tween = Tween.new()
	add_child(tween)

func flip_spr(dirx, spr):
	if dirx > 0:
		spr.flip_h = false
	elif dirx < 0:
		spr.flip_h = true

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
	p_pos = world.player.map_pos

func end_turn():
	pass

func set_map_pos(v):
	map_pos = v
	#position = map_pos * 16 + Vector2(8, 8)
	if tween:
		var target = map_pos * 16 + Vector2(8, 8)
		var diff = position - target
		tween.interpolate_property(self, "position", position, target, \
		0.15 * diff.length() / 16, Tween.TRANS_QUAD,
		Tween.EASE_OUT)
		tween.start()
	else:
		position = map_pos * 16 + Vector2(8, 8)

func die():
	world.delete_entity(self)

func damage():
	pass

func set_hp(v):
	if v < hp:
		tween.interpolate_property(self, "modulate", Color(10, 10, 10),
		Color(1, 1, 1), 0.25, Tween.TRANS_QUAD,
		Tween.EASE_OUT)
		tween.start()
		damage()
	elif v > hp:
		pass
	hp = v
	
	if hp <= 0:
		die()
