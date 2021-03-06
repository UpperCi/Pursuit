extends Node

const FADE_TIME = 0.4

onready var songs = get_children()
onready var anim = $AnimationPlayer
onready var music_bus = AudioServer.get_bus_index("Music")

export var vol = 1.0
var time_left = 100
var new_song = false
var animating = 0

func queue_song(song):
	for s in songs:
		if s.playing:
			if s.name == "Menu":
				s.playing = false
				s.stop()
				continue
			s.queued_song = song
			new_song = true
			return
	play(song)

func play(song):
	for s in songs:
		if s.name == song:
			s.playing = true
			s.cycle_timer = 1
		elif s.playing:
			s.stop()

func stop():
	for s in songs:
		s.stop()

func _process(delta):
	# fade out
	if time_left < FADE_TIME:
		if new_song and not animating:
			anim.play("fade_song")
			animating = true
	if animating:
		var true_vol = linear2db(vol)
		AudioServer.set_bus_volume_db(music_bus, true_vol)

func _ready():
	songs.erase(anim)

func _on_AnimationPlayer_animation_finished(anim_name):
	animating = false
	new_song = false
	AudioServer.set_bus_volume_db(music_bus, 0)
