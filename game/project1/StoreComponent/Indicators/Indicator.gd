extends AnimatedSprite2D

func init(pos:Vector2,type:String,time:float = 5)->void:
	Global.current_store.add_child(self)
	position = pos
	play(type)
	var tween = create_tween()
	tween.tween_interval(time)
	await tween.finished
	var tween1 = create_tween()
	tween1.tween_property(self,"modulate",Color(255,255,255,0),time)
	await tween1.finished
	queue_free()
