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

func _on_MenuButton_mouse_entered():
	SFX.play("ui_menu_hoverOverButton_1")

func _on_MenuButton_focus_entered():
	SFX.play("ui_menu_hoverOverButton_1")

func _on_MenuButton_button_down():
	SFX.play("ui_menu_clickButton_1")
