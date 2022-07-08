extends Node2D

enum ROOM_TYPES {
	EXPLORATION,
	COMBAT,
	PUZZLE,
	SHRINE
}

export (ROOM_TYPES) var type

var entities = []
var items = []
var player = null
var turn_index = 0
var tiles = []

onready var entity_node = $Entities
onready var item_node = $Items
onready var tilemap = $Tiles

func get_entities():
	entities = []
	for c in entity_node.get_children():
		entities.push_back(c)

func get_items():
	items = []
	for c in item_node.get_children():
		items.push_back(c)

func get_cell(pos: Vector2):
	var entity = false
	var item = false
	var tile = tilemap.get_cell(pos.x, pos.y)
	
	for e in entities:
		if e.map_pos == pos:
			entity = e
			break
	
	for i in items:
		if i.map_pos == pos:
			item = i
			break
	
	return {
		"tile": tile,
		"entity": entity,
		"item": item,
		"valid_move": (tile == -1 && not entity)
	}

func _ready():
	get_entities()
	get_items()
	
	match type:
		ROOM_TYPES.COMBAT:
			Music.queue_song("Combat")
		ROOM_TYPES.EXPLORATION:
			Music.queue_song("Exploration")
		ROOM_TYPES.PUZZLE:
			Music.queue_song("Puzzle")
		ROOM_TYPES.SHRINE:
			Music.queue_song("Shrine")

func update_turn():
	var current_entity = entities[turn_index]
	if (current_entity.take_turn()):
		current_entity.end_turn()
		turn_index += 1
		turn_index = turn_index % len(entities)
		entities[turn_index].turn += 1
		entities[turn_index].start_turn()

func create_item(i):
	items.push_back(i)
	item_node.add_child(i)

func delete_item(i):
	items.erase(i)
	i.queue_free()

func move_entity(e, new_pos: Vector2):
	if get_cell(new_pos).valid_move:
		e.map_pos = new_pos
		return true
	return false

func delete_entity(e):
	entities.erase(e)
	e.queue_free()

func _process(delta):
	update_turn()

func create_path_node(pos: Vector2, prev: int, nodes):
	return {
		"pos": pos,
		"prev": prev,
		"dist": nodes[prev].dist + 1,
		"passed": false
	}

func pos_in(pos: Vector2, path_nodes):
	for n in path_nodes:
		if n.pos == pos:
			return true
	return false

func add_item(item):
	pass

func find_path(start: Vector2, end: Vector2):
	var path_nodes = [{"pos": start, "prev": null, "dist": 0, "passed": false}]
	# step
	while true:
		var shortest_node = null
		var shortest_i = 0
		var shortest_dist = 1000
		
		for i in range(len(path_nodes)):
			var n = path_nodes[i]
			if not n.passed and n.dist < shortest_dist:
				shortest_dist = n.dist
				shortest_i = i
				shortest_node = n
		
		for dir in [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT]:
			var pos = shortest_node.pos + dir
			if pos == end:
				var path = []
				var current_node = create_path_node(pos, shortest_i, path_nodes)
				while current_node.prev != null:
					path.push_back(current_node.pos)
					current_node = path_nodes[current_node.prev]
				return path
			if pos_in(pos, path_nodes):
				continue
			if not get_cell(pos).valid_move:
				continue
			path_nodes.push_back(create_path_node(pos, shortest_i, path_nodes))
		
		shortest_node.passed = true
