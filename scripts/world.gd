extends Node2D

enum ROOM_TYPES {
	EXPLORATION,
	COMBAT,
	PUZZLE,
	SHRINE
}

export (ROOM_TYPES) var type
export (bool) var talk = true
export (String, FILE) var spit = ""

const DIRS = [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT]

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
	var closed_exit = false
	var chest = false
	
	for e in entities:
		if e.map_pos == pos:
			entity = e
			break
	
	for i in items:
		if i.map_pos == pos:
			item = i
			if i.type == i.ITEM_TYPES.EXIT:
				closed_exit = not i.is_open
			if i.type == i.ITEM_TYPES.CHEST:
				chest = true
			break
	
	return {
		"tile": tile,
		"entity": entity,
		"item": item,
		"valid_move": (tile == -1 && not entity && not closed_exit),
		"valid_path": (tile == -1 && not chest)
	}

func _ready():
	randomize()
	if talk:
		Universe.talk()
	elif spit != "":
		Universe.spit(spit)
	
	get_entities()
	get_items()
	update_exits()
	
	match type:
		ROOM_TYPES.COMBAT:
			Music.queue_song("Combat")
		ROOM_TYPES.EXPLORATION:
			Music.queue_song("Exploration")
		ROOM_TYPES.PUZZLE:
			Music.queue_song("Puzzle")
		ROOM_TYPES.SHRINE:
			Music.queue_song("Shrine")

func line_of_sight(start: Vector2, end: Vector2):
	for point in line(start, end):
		var cell = get_cell(point)
		if not cell.valid_path:
			return false
	return true

# Amit Patel’s algorithm ( https://www.redblobgames.com )
# Implementation: https://godotengine.org/qa/35276/tile-based-line-drawing-algorithm-efficiency
func line(start: Vector2, end: Vector2):
	var dx = end.x - start.x
	var dy = end.y - start.y
	var nx = abs( dx )
	var ny = abs( dy )
	var signX = sign( dx )
	var signY = sign( dy )
	var p = start
	var points : Array = [p]
	
	var ix = 0
	var iy = 0
	
	while ix < nx || iy < ny:
		if ( ( 1 + ( ix << 1) ) * ny < ( 1 + ( iy << 1) ) * nx ):
			p.x += signX
			ix +=1
		else:
			p[1] += signY
			iy += 1
		points.append(p)
	return points

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
	var cell = get_cell(new_pos)
	if cell.valid_move:
		if cell.item:
			if cell.item.type == cell.item.ITEM_TYPES.CHEST:
				cell.item.open()
				SFX.play_random("treasureChest", 6)
				VFX.create("Open", new_pos, new_pos, self)
				return true
			if cell.item.type == cell.item.ITEM_TYPES.HEART:
				if e.is_player:
					if e.hp != e.max_hp:
						delete_item(cell.item)
						SFX.play_random("pickUp_heart", 6)
						cell.item = false
						VFX.create("Open", new_pos, new_pos, self)
						e.hp += 1
		e.map_pos = new_pos
		return true
	return false

func update_exits():
	for e in entities:
		if not e.is_player:
			return
	for i in items:
		if i.type == i.ITEM_TYPES.EXIT:
			i.open()
	

func delete_entity(e):
	entities.erase(e)
	e.queue_free()
	update_exits()

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
	items.push_back(item)
	item_node.add_child(item)

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
		
		for dir in DIRS:
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
			if not get_cell(pos).valid_path:
				continue
			path_nodes.push_back(create_path_node(pos, shortest_i, path_nodes))
		
		shortest_node.passed = true
