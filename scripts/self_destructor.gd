extends AudioStreamPlayer

func _on_SelfDestructor_finished():
	queue_free()
