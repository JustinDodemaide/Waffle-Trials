extends CanvasLayer

var player:Player

func init(_player:Player):
	player = _player
	var valid_options = []
	var options = ["deposit","use","collect"]
	#print("making options")
	for i in options:
		player.option = i
		if player.current_interactable.is_interaction_valid(player):
			valid_options.append(i)
	if valid_options.size() == 1:
		player.option_chosen(valid_options[0])
		return
	for i in valid_options:
		make_option_button(i)
	
func make_option_button(option:String):
	var button = $HBoxContainer/Button.duplicate()
	button.text = option
	button.visible = true
	$HBoxContainer.add_child(button)
	

func _on_button_option_chosen(option):
	player.option_chosen(option)
