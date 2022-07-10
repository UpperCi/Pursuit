extends Control

onready var crt = $CanvasLayer/PostProcess
onready var trans = $CanvasLayer/Transition/TextureRect.get_material()

func _process(delta):
	if Input.is_action_just_pressed("toggle_shader"):
		crt.visible = not crt.visible

func set_trans(time):
	trans.set_shader_param("trans_time", time)
