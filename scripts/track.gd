extends Node

export var duration = 8.175
export var chance = 1.0
export var sync_id = 2
export (Array, String, FILE) var files = []

var timer = 0
var player: AudioStreamPlayer
var streams: Array = []

func _ready():
	player = AudioStreamPlayer.new()
	player.bus = "Music"
	add_child(player)
	
	for f in files:
		streams.push_back(load(f))

func shuffle():
	if len(streams) <= 0:
		stop()
		return
	var stream = streams[randi() % len(streams)]
	player.stream = stream
	player.play(0.0)
	print(name)

func stop():
	player.stop()
	player.stream = null
