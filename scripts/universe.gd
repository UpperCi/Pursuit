extends Node

const MAX_PAST_TYPES = 3
const REROLLS = 1
const GOD_VOICES = 29
const HERO_VOICES = 26

export var player_weapon_start: PackedScene
export var player_spell_start: PackedScene
export (Array, PackedScene) var rooms

var player_weapon: Node2D
var player_spell: Node2D
var past_types = [0]
var room_num = 0
var player_hp = 6
var played_voices = []

onready var total_voices = GOD_VOICES + HERO_VOICES
onready var talker = $Voice

func _ready():
	player_weapon = player_weapon_start.instance()
	player_spell = player_spell_start.instance()

func talk():
	if len(played_voices) >= total_voices:
		played_voices = []
	while true:
		var voice = randi() % total_voices
		if not (voice in played_voices):
			played_voices.push_back(voice)
			var file = "res://assets/ost/voices/voiceOver_"
			if voice >= GOD_VOICES:
				voice -= GOD_VOICES
				file += "hero_"
			else:
				file += "god_"
			file += "%02d.ogg" % [voice + 1]
			talker.stream = load(file)
			talker.play()
			return

func get_random_room():
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
