extends CanvasLayer

func init():
	var options = ["Waffle","Hashbrowns","ScrambledEggs","Toast"]
	for i in options:
		var new_button = $HBoxContainer/Button.duplicate()
		var item = Item.new()
		item.init(i)
		new_button.icon = load(item.sprite_path())
		new_button.visible = true
		set_meta("Item", i)
		new_button.tooltip_text = i
		$HBoxContainer.add_child(new_button)
