extends "res://scripts/item.gd"

export (Array, String) var weapons = [\
"Spear","Bow","Hammer","Hook","Dagger","Locket"]
export (Array, String) var spells = [\
"Missile","Earthquake","Poison","Firebolt","Shield","Teleport"]

func open():
	var items = []
	var _weapons = weapons.duplicate(true)
	var _spells = spells.duplicate(true)
	var item_type = -1
	if Universe.banned_item != -1:
		item_type = (Universe.banned_item + 1) % 2
		Universe.banned_item = -1
	else:
		item_type = randi() % 2
	if Universe.last_item == item_type:
		Universe.banned_item = item_type
	else:
		Universe.last_item = item_type
	
	items = [_weapons, _spells][item_type]
	if len(items) > 1 and item_type == 1:
		items.erase(world.player.spell.item_name)
	if len(items) > 1 and item_type == 0:
		items.erase(world.player.weapon.item_name)
	if Universe.banned_item != -1:
		pass
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
