extends Node

signal things_set

var settings = {}

func _ready():
	self.connect("things_set", self, "update_audio")
	self.connect("things_set", self, "update_gfx")
	load_save()
	emit_signal("things_set")

func update_bus(bus, vol):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus),\
	linear2db(get_or(vol, 1)))

func update_audio():
	update_bus("Master", "master_volume")
	update_bus("Music_Mod", "music_volume")
	update_bus("SFX", "sfx_volume")
	update_bus("Voice_Mod", "voice_volume")

func map_range(mn, mx, v):
	return mn + (mx - mn) * v

func update_gfx():
	if get_or("filter_enabled", false):
		Gfx.crt.visible = true
		var crt = Gfx.crt.get_node("TextureRect").get_material()
		crt.set_shader_param("slot_mask", get_or("filter_slotted", true))
		
		var stretch = get_or("filter_stretch", 0.5)
		if stretch > 0.025:
			crt.set_shader_param("stretch_screen", true)
			crt.set_shader_param("stretch", map_range(0, 0.5, stretch))
			crt.set_shader_param("zoom", map_range(1, 0.9, stretch))
		else:
			crt.set_shader_param("stretch_screen", false)
		
		var scan = get_or("filter_scanline", 0.5)
		if scan > 0.025:
			crt.set_shader_param("do_scanline", true)
			crt.set_shader_param("scan_min", map_range(0.5, 0.0, scan))
			crt.set_shader_param("scan_max", map_range(0.5, 1.0, scan))
		else:
			crt.set_shader_param("do_scanline", false)
		
		var sub = get_or("filter_subpixel", 0.4)
		if sub > 0.025:
			crt.set_shader_param("do_subpixel", true)
			crt.set_shader_param("rgb_min", map_range(0.6, 0.0, sub))
			crt.set_shader_param("rgb_treshold", map_range(0.0, 0.7, sub))
			crt.set_shader_param("rgb_mult", map_range(1.0, 1.1, sub))
		else:
			crt.set_shader_param("do_subpixel", false)
			
		var ns = get_or("filter_noise", 0.5)
		crt.set_shader_param("noise_mult", map_range(0.0, 0.2, ns))
		
		var bck = get_or("filter_backlight", 0.4)
		crt.set_shader_param("backlight", map_range(0.0, 0.6, bck))
	else:
		Gfx.crt.visible = false

func set_thing(k, v):
	settings[k] = v
	emit_signal("things_set")

func get_or(k, v):
	var kv = get_thing(k)
	if kv == null:
		return v
	return kv

func get_thing(k):
	if k in settings:
		return settings[k]
	return null

func load_save():
	var f = File.new()
	if not f.file_exists("user://pursuit.json"):
		save()
		return
	f.open("user://pursuit.json", File.READ)
	settings = parse_json(f.get_as_text())
	f.close()

func save():
	var f = File.new()
	f.open("user://pursuit.json", File.WRITE)
	f.store_string(to_json(settings))
	f.close()
