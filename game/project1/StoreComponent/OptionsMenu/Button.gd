extends Button

signal option_chosen(option)

func _on_pressed():
	emit_signal("option_chosen", text)
