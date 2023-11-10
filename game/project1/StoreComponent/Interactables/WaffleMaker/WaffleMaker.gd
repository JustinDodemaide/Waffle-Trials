extends Interactable

func _ready():
	Global.world.world_clock.timeout.connect(_on_timer_timeout)
		
func a_name()->String:
	return "Waffle Maker"

func max_storage()->int:
	return 1

func effect()->String:
	return "waffle"

func effect_strength()->int:
	return 1

func deposit_attributes()->PackedStringArray:
	return ["waffleable"]

func is_interaction_valid(interactor)->bool:
	var option:String = ""
	if interactor is Player:
		option = interactor.option
	else:
		option = interactor.current_task.option
	if option == "deposit":
		return false
	#if option == "deposit":
	#	if interactor.is_empty_handed():
	#		return false
	#	if is_full():
	#		return false
	#	if not Global.has_intersection(interactor.carried_item.attributes(), deposit_attributes()):
	#		return false
	if option == "collect":
		if is_empty():
			return false
		if storage.back().a_name() == "Waffle Batter":
			return false # special case to prevent scooping waffle batter out of an iron with your bare hands
		if interactor is Employee:
			if interactor.current_task.required_item != null:
				if not has(interactor.current_task.required_item):
					return false
	if option == "use":
		if is_full():
			return false
	return true

func interact(interactor)->void:
	var option:String = ""
	if interactor is Player:
		option = interactor.option
	else:
		option = interactor.current_task.option
	if option == "use":
		var item:Item = Global.new_item("WaffleBatter")
		add_item(item)
		$Sound.play_sound("sizzle")
	if option == "collect":
		var item:Item
		if interactor is Employee:
			item = get_item(interactor.current_task.required_item)
		if interactor is Player:
			item = get_back_item()
		interactor.carry_item(item)

func update_display():
	if has_node("AnimatedSprite2D"):
		if !is_empty():
			if storage.back().a_name() == "Waffle":
				$AnimatedSprite2D.play("done")
			elif storage.back().a_name() == "Rubbish":
				$AnimatedSprite2D.play("burnt")
			else:
				$AnimatedSprite2D.play("on")
		if is_empty():
			$AnimatedSprite2D.play("off")
	if has_node("DisplayedItem"):
		if is_empty():
			$DisplayedItem.texture = null
		else:
			$DisplayedItem.texture = load(storage.back().sprite_path())
