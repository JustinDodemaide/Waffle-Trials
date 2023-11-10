extends Area2D
class_name MouseClickShape

func _ready():
	position = get_global_mouse_position()
	var tween:Tween = create_tween()
	tween.tween_property($Sprite2D,"scale",Vector2(0.3,0.3),0.1)
	await tween.finished
	tween.stop()
	var tween2:Tween = create_tween()
	tween2.tween_property($Sprite2D,"scale",Vector2(0.158,0.158),0.5).set_trans(Tween.TRANS_ELASTIC)
	await tween2.finished
	queue_free()

func _on_area_entered(area):
	if area is MouseClickShape:
		return
	get_parent().object_selected(area)
	print(area.name + " clicked on")
