extends HBoxContainer

func init(order:Array[Item]):
	for i in order:
		var c = $Control.duplicate()
		c.visible = true
		c.get_node("Sprite2D").texture = load(i.sprite_path())
		add_child(c)
		pass
