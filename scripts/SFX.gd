extends Node

onready var destructor = preload("res://scenes/SelfDestructor.tscn")

func play_random(sound, max_i):
	var new_sound = sound + "_0" + str(randi() % max_i + 1)
	play(new_sound)

func play(sound):
	var stream = load("res://assets/ost/sfx/sfx_" + sound + ".wav")
	var node = destructor.instance()
	node.bus = "SFX"
	node.stream = stream
	node.play()
	add_child(node)
