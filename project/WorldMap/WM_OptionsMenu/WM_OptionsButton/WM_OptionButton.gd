extends Button

signal option_button_pressed(option:String)

func init(option):
	text = option

func _on_pressed():
	print("option button pressed")
	emit_signal("option_button_pressed",text)
