extends Control

onready var crt = $CanvasLayer/PostProcess

func _process(delta):
	if Input.is_action_just_pressed("toggle_shader"):
		crt.visible = not crt.visible
