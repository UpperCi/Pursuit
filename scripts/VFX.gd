extends Node2D

func create(effect: String, start_pos: Vector2, end_pos: Vector2,
	world, hits = []):
	var node = load("res://scenes/effects/" + effect + ".tscn").instance()
	node.start_pos = start_pos
	node.end_pos = end_pos
	node.hits = hits
	world.add_child(node)
	return node
