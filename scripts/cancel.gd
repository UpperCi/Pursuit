tool
extends "res://scripts/menubutton.gd"

func _pressed():
	get_tree().paused = false
	get_parent().get_parent().get_parent().queue_free()
