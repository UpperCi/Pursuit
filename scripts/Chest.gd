extends "res://scripts/item.gd"

export (Array, String) var items = ["Spear","Poison","Firebolt","Bow","Hammer","Missile","Earthquake"]

func open():
	var item = items[randi() % len(items)]
	var item_scene = load("res://scenes/items/" + item + ".tscn")
	var item_origin = item_scene.instance()
	var item_node = load("res://scenes/Item.tscn").instance()
	item_node.img = item_origin.img
	item_node.target_weapon = item_scene
	item_origin.queue_free()
	item_node.start_pos = map_pos
	world.delete_item(self)
	world.add_item(item_node)
