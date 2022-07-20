extends Control

onready var main = $Main
onready var audio = $Audio
onready var filter = $Filter

onready var backs = [$Audio/VBoxContainer/Back, $Filter/VBoxContainer/Back]

func _ready():
	for back in backs:
		back.connect("pressed", self, "_on_back_pressed")

func _on_back_pressed():
	audio.visible = false
	filter.visible = false
	main.visible = true
	Settings.save()

func _on_Audio_pressed():
	main.visible = false
	audio.visible = true

func _on_Filter_pressed():
	main.visible = false
	filter.visible = true
