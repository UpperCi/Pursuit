extends Control

onready var crt = $CanvasLayer/BackBufferCopy2/PostProcess
onready var trans = $CanvasLayer/BackBufferCopy/Transition/TextureRect.get_material()
onready var tiles = $CanvasLayer2/TileMap

func _process(delta):
	if Input.is_action_just_pressed("toggle_shader"):
		crt.visible = not crt.visible

func set_trans(time):
	trans.set_shader_param("trans_time", time)

func update_tiles():
	tiles.update_bitmask_region(Vector2.ZERO, Vector2(15, 8))
