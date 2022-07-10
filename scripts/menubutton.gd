tool
extends TextureButton

export var text = "" setget set_text

func set_text(v):
	text = v
	if Engine.is_editor_hint():
		get_node("txt").text = text
		get_node("bg").text = text

func _ready():
	get_node("txt").text = text
	get_node("bg").text = text

func _process(delta):
	if not (get_draw_mode() in [1]):
		get_node("bg").visible = true
		get_node("txt").margin_top = 0
	else:
		get_node("bg").visible = false
		get_node("txt").margin_top = 2
