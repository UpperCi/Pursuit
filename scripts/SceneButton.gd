tool
extends "res://scripts/menubutton.gd"

export (String, FILE) var path = ""

func _pressed():
	SceneSwitcher.switch(load(path))
	pass
