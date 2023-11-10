extends Interactable

func a_name()->String:
	return "Heat Lamp"

func max_storage()->int:
	return 1

func effect()->String:
	return "warm"

func effect_strength()->int:
	return 1

func is_interaction_valid(interactor)->bool:
	var option = get_option(interactor)
	if option == "deposit":
		if interactor.is_empty_handed():
			return false
		if is_full():
			return false
		#if not Global.has_intersection(interactor.carried_item.attributes(), deposit_attributes()):
		#	return false
	if option == "collect":
		if is_empty():
			return false
		if interactor is Employee:
			if interactor.current_task.required_item != null:
				if not has(interactor.current_task.required_item):
					return false
	if option == "use":
		return can_interactor_use(interactor)
	return true


func interact(interactor)->void:
	var option:String = ""
	if interactor is Player:
		option = interactor.option
	else:
		option = interactor.current_task.option
	if option == "deposit" || option == "collect":
		var temp:Item = get_back_item()
		var item = interactor.carried_item
		if item != null:
			interactor.remove_item()
			add_item(item)
		if temp != null:
			interactor.carry_item(temp)
