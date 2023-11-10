extends PanelContainer
class_name WM_OptionsMenu

var option_state = null

func init(wo:WorldMapObject):
	print("making options menu for world object: ", wo.name)
	for i in wo.object.options():
		var button = preload("res://WorldMap/WM_OptionsMenu/WM_OptionsButton/WM_OptionButton.tscn").instantiate()
		button.init(i)
		button.option_button_pressed.connect(option_state.option_chosen)
		add_child(button)
