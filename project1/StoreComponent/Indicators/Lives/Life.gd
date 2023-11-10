extends Control

func lose_life():
	$Life.texture = load("res://StoreComponent/Indicators/Lives/frown.png")
	var color_tween = create_tween()
	color_tween.tween_property(self,"modulate",Color.RED,0.5)
	
	var size_tween1 = create_tween()
	size_tween1.tween_property(self,"scale",Vector2(2,2),0.25).set_ease(Tween.EASE_IN)
	await size_tween1.finished
	
	var size_tween2 = create_tween()
	size_tween2.tween_property(self,"scale",Vector2(1,1),0.5).set_trans(Tween.TRANS_BOUNCE)
	await size_tween2.finished

	var new_modulate = modulate
	new_modulate.a = 0
	var color_tween2 = create_tween()
	color_tween2.tween_property(self,"modulate",new_modulate,2)
	await color_tween2.finished
	queue_free()
