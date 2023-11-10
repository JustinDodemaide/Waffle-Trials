extends Button

var parent
var item_name

func _on_pressed():
	parent.emit_signal("option_chosen",item_name)
