extends Interactable

var item:Item

func _ready():
	Global.world.world_clock.timeout.connect(_on_world_clock_timeout)

func init(i:Item):
	item = i
	if item.a_name() == "Plate":
		$Sprite2D.add_child(item.sprite())
		return
	$Sprite2D.texture = load(item.sprite_path())
	item.transformed.connect(item_transformed)

func item_transformed()->void:
	$Sprite2D.texture = load(item.sprite_path())
	
func a_name()->String:
	return item.a_name()
	
func max_storage()->int:
	return 0
	
func has(i:Item)->bool:
	if item.equals(i):
		return true
	return false

func is_interaction_valid(_interactor)->bool:
	var option:String = ""
	if _interactor is Player:
		option = _interactor.option
	else:
		option = _interactor.current_task.option
	if option == "collect":
		return true
	if option == "deposit":
		if item.a_name() != "Plate":
			return false
		if item.full():
			return false
		if _interactor.carried_item == null:
			return false
		if _interactor.carried_item.attributes().has("plateable"):
			return true
	return false
	
func interact(_interactor)->void:
	var option:String = ""
	if _interactor is Player:
		option = _interactor.option
	else:
		option = _interactor.current_task.option
	if option == "collect":
		_interactor.carry_item(item)
		queue_free()
	if option == "deposit":
		item.add_item(_interactor.carried_item)
		for i in $Sprite2D.get_children():
			i.queue_free()
		$Sprite2D.add_child(item.sprite())
		_interactor.remove_item()
		$Sprite2D.texture = load(item.sprite_path())
	
func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"item data" : item.save()
	}
	return save_dict
	
func _on_world_clock_timeout():
	item.apply_effect("exposure")

func _load(node_data:Dictionary):
	position.x = node_data["pos_x"]
	position.y = node_data["pos_y"]
	var new_item = load("res://World/Items/Item.tscn").instantiate()
	new_item._load(node_data["item data"])
	init(new_item)
