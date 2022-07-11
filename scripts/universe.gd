extends Node

const MAX_PAST_TYPES = 3
const REROLLS = 1
const GOD_VOICES = 29
const HERO_VOICES = 26

export (Array, PackedScene) var rooms = []

var player_weapon: PackedScene
var player_spell: PackedScene
var past_types = [0]
var room_num = 0
var player_hp = 6
var played_voices = []
var seen_items = []
var tutorial_level = 0

onready var total_voices = GOD_VOICES + HERO_VOICES
onready var talker = $Voice
onready var nothing = preload("res://scenes/items/Nothing.tscn")
onready var bus = AudioServer.get_bus_index("Voice")

func _ready():
	player_weapon = nothing
	player_spell = nothing

func talk():
	if len(played_voices) >= total_voices:
		played_voices = []
	while true:
		var voice = randi() % total_voices
		if not (voice in played_voices):
			var vol = 2
			played_voices.push_back(voice)
			var file = "res://assets/ost/voices/voiceOver_"
			if voice >= GOD_VOICES:
				voice -= GOD_VOICES
				file += "hero_"
			else:
				vol = -1
				file += "god_"
			file += "%02d.ogg" % [voice + 1]
			spit(file, vol)
			return

func spit(line, vol = -7):
	AudioServer.set_bus_volume_db(bus, vol)
	talker.stop()
	talker.stream = load(line)
	talker.play()

func get_random_room():
	if tutorial_level < 3:
		var room_scene = "res://scenes/rooms/tutorial_" + \
		str(tutorial_level + 1) + ".tscn"
		tutorial_level += 1
		room_num -= 1
		return load(room_scene)
	tutorial_level = 4
	var room_scene = rooms[randi() % len(rooms)]
	var room = room_scene.instance()
	var rerolls = REROLLS
	while true:
		if past_types[len(past_types) - 1] == room.type:
			room_scene = rooms[randi() % len(rooms)]
			room = room_scene.instance()
			continue
		if room.type in past_types and rerolls > 0:
			room_scene = rooms[randi() % len(rooms)]
			room = room_scene.instance()
			rerolls -= 1
			continue
		break
	past_types.push_back(room.type)
	if len(past_types) > MAX_PAST_TYPES:
		past_types.pop_front()
	print(past_types)
	return room_scene
