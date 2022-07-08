extends Node

const FADE_TIME = 0.25

onready var songs = get_children()
onready var tween = $Tween
onready var music_bus = AudioServer.get_bus_index("Music")

var vol = 1.0
var time_left = 100
var tweening = false
var new_song = false

func queue_song(song):
	for s in songs:
		if s.playing:
			s.queued_song = song
			return
	play(song)

func play(song):
	for s in songs:
		if s.name == song:
			s.playing = true
			s.cycle_timer = 1
			new_song = true
		elif s.playing:
			s.stop()

func _process(delta):
	#var vol = linear2db(track.timer * 2 + 0.1) - 5
	#AudioServer.set_bus_volume_db(music_bus, vol)
	
	# fade out
	if time_left < FADE_TIME:
		if new_song and not tweening:
			tween.interpolate_property(self, "vol", 1.0, 0.0, FADE_TIME,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tweening = true
			tween.start()
	if tweening:
		AudioServer.set_bus_volume_db(music_bus, linear2db(vol))

func _ready():
	songs.erase(tween)
	pass

func _on_Tween_tween_completed(object, key):
	tweening = false
	if new_song:
		new_song = false
		tween.interpolate_property(self, "vol", 0.0, 1.0, FADE_TIME,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tweening = true
		tween.start()
	else:
		AudioServer.set_bus_volume_db(music_bus, 0)
