extends ProgressBar

signal finished

func start(time:float)->void:
	max_value = time
	value = time
	var tween = create_tween()
	tween.tween_property(self,"value",0,time)
	await tween.finished
	emit_signal("finished")
	queue_free()

func start_partial(time:float,max_time:float):
	max_value = max_time
	if time > max_time:
		time = max_time
	value = time
	var tween = create_tween()
	tween.tween_property(self,"value",0,time)
	await tween.finished
	emit_signal("finished")
	queue_free()
