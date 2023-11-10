extends AudioStreamPlayer2D

func play_sound(sound:String,self_destruct:bool = false):
	stream = load("res://sounds/" + sound + ".mp3")
	play()
	if self_destruct:
		await finished
		queue_free()
