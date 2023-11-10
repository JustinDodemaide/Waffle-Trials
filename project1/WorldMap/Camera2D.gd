extends Camera2D

signal done_moving

var speed:int = 500
func _process(delta):
	if Input.is_action_pressed("D"):
		position += Vector2(speed * delta, 0)
	if Input.is_action_pressed("A"):
		position += Vector2(-speed * delta, 0)
	if Input.is_action_pressed("W"):
		position += Vector2(0, -speed * delta)
	if Input.is_action_pressed("S"):
		position += Vector2(0, speed * delta)

func move_camera_to(target:Vector2):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "position", target, 0.33)
	await tween.finished
	emit_signal("done_moving")
