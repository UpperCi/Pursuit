extends AudioStreamPlayer

export var destroy = false

func _on_SingleAudio_finished():
	stop()
	if destroy: 
		queue_free()
