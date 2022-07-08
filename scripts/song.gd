extends Node

onready var tracks = get_children()
var playing = false
var queued_song = null

var cycle_timer = 0

func new_sound(track):
	track.timer = track.duration + AudioServer.get_time_to_next_mix()
	if randf() < track.chance:
		track.shuffle()
		for t in tracks:
			if t != track and track.sync_id == t.sync_id:
				t.shuffle()
	else:
		track.stop()

func stop():
	playing = false
	for track in tracks:
		track.stop()

func _process(delta):
	if not playing:
		return
	for track in tracks:
		if track.timer <= 0:
			if queued_song:
				get_parent().play(queued_song)
				queued_song = null
				return
			new_sound(track)
		else:
			track.timer -= delta
			if track.name == "Base":
				get_parent().time_left = track.timer
