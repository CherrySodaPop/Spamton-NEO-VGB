extends AudioStreamPlayer

func _process(delta):
	if (!playing): queue_free();
