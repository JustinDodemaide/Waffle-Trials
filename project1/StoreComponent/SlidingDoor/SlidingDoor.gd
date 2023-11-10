extends AnimatedSprite2D

func _ready():
	play("close")

func _on_area_2d_area_entered(_area):
	if is_playing():
		await animation_finished
	play("open")

func _on_area_2d_area_exited(_area):
	if is_playing():
		await animation_finished
	play("close")
