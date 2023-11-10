extends Node2D
class_name Interactable

var storage:Array[Item] = []
signal complete

func a_name()->String:
	return "Interactable"
	
func deposit_attributes()->PackedStringArray:
	return [""]
	
func max_storage()->int:
	return 1

func uses_storage()->bool:
	return max_storage() != 0

func add_item(item:Item)->void:
	storage.append(item)
	update_display()

func has(item:Item)->bool:
	for i in storage:
		if i.a_name() == item.a_name():
			return true
	return false

func get_back_item()->Item:
	var item = storage.pop_back()
	update_display()
	return item

func get_item(item:Item)->Item:
	var index:int = 0;
	for i in storage:
		if i.a_name() == item.a_name():
			storage.remove_at(index)
			update_display()
			if is_empty() and has_node("AnimatedSprite2D"):
				$AnimatedSprite2D.play("off")
			return i
		index += 1
	return null
	
func is_full()->bool:
	return storage.size() == max_storage()
func is_empty()->bool:
	return storage.size() <= 0

func effect_strength()->int:
	return 1

func apply_effect():
	#print("applying effects")
	for item in storage:
		for i in effect_strength():
			item.apply_effect(effect())
	update_display()
		
func effect()->String:
	# always a verb
	return ""

func required_item()->Item:
	return null

func get_option(interactor)->String:
	var option:String = ""
	if interactor is Player:
		option = interactor.option
	else:
		option = interactor.current_task.option
	return option

func is_interaction_valid(interactor)->bool:
	var option = get_option(interactor)
	if option == "deposit":
		if interactor.is_empty_handed():
			return false
		if is_full():
			return false
		if not Global.has_intersection(interactor.carried_item.attributes(), deposit_attributes()):
			return false
	if option == "collect":
		if is_empty():
			return false
		if interactor.carried_item != null:
			return false
		if interactor is Employee:
			if interactor.current_task.required_item != null:
				if not has(interactor.current_task.required_item):
					return false
	if option == "use":
		return can_interactor_use(interactor)
	return true

func can_interactor_use(_interactor)->bool:
	# a specific function for "use" that can be defined without needing to
	# copy/paste the entire "is_interaction_valid" function
	return false

func interact(interactor)->void:
	var option:String = ""
	if interactor is Player:
		option = interactor.option
	else:
		option = interactor.current_task.option
	if option == "deposit":
		var item:Item = interactor.carried_item
		interactor.remove_item()
		add_item(item)
	if option == "collect":
		var item:Item
		if interactor is Employee:
			item = get_item(interactor.current_task.required_item)
		else:
			item = get_back_item()
		interactor.carry_item(item)
	if option == "use":
		use(interactor)

func use(_interactor)->void:
	pass
	
func _on_timer_timeout():
	apply_effect()
	
func update_display():
	if has_node("AnimatedSprite2D"):
		if !is_empty():
			$AnimatedSprite2D.play("on")
		if is_empty():
			$AnimatedSprite2D.play("off")
	if has_node("DisplayedItem"):
		if is_empty():
			$DisplayedItem.texture = null
		else:
			$DisplayedItem.texture = load(storage.back().sprite_path())

var has_outline:bool = false
func make_outline()->void:
	if has_node("AnimatedSprite2D"):
		if has_outline:
			return
		has_outline = true
		# Texture2D get_frame_texture(anim: StringName, idx: int) const
		var frame = $AnimatedSprite2D.sprite_frames.get_frame_texture("off",0)
		var sprite = Sprite2D.new()
		sprite.texture = frame
		sprite.scale = Vector2(1.1,1.1)
		sprite.modulate = Color.BLACK
		add_child(sprite)
		#print("new sprite")
		var tween = create_tween()
		tween.tween_property(sprite,"modulate",Color(0,0,0,0),3)
		await tween.finished
		sprite.queue_free()
		has_outline = false
		

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y
	}
	return save_dict

func _load(node_data:Dictionary):
	position.x = node_data["pos_x"]
	position.y = node_data["pos_y"]
