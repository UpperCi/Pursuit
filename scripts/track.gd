extends Node

export var duration = 8.74
export var chance = 1.0
export var sync_id = 2
export (Array, String, FILE) var files = []

var timer = 0
var players = []

func _ready():
	for f in files:
		var player = AudioStreamPlayer.new()
		player.bus = "Music"
		player.stream = load(f)
		player.autoplay = false
		add_child(player)
		players.push_back(player)
		player.play(8.7)

func shuffle():
	var player: AudioStreamPlayer = players[randi() % len(players)]
	player.play()

func stop():
	for player in players:
		player.stop()
