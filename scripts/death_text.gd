extends Label

func _ready():
	text = "You conquered " + str(Universe.room_num) + " levels."
	Universe.room_num = 0

