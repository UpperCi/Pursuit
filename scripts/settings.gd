extends Node

export var change_signal = "value_changed"
export var setting = "temp"
export var attr = "value"
onready var default = get(attr)

func _ready():
	self.connect(change_signal, self, "update_value")
	self.set(attr, Settings.get_or(setting, default))

func update_value(v = null):
	Settings.set_thing(setting, self.get(attr))
