extends VBoxContainer

func _ready():
	for c in get_children():
		c.connect("pressed", self, "resume")

func resume():
	print("mogus")
	get_tree().paused = false
	get_parent().get_parent().queue_free()
