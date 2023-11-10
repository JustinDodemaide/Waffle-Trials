extends RefCounted
class_name Item

signal transformed(item_name:String)

func init(item_name:String)->void:
	var script = load("res://World/Items/" + item_name + "/" + item_name + ".gd")
	#assert(script == null, "Item not found")
	set_script(script)
	#item_transformed()

####################### NEEDS TO BE DEFINED INDIVIDUALLY FOR EVERY ITEM ############################

func a_name()->String:
	return "Item"
	
func file_path()->String:
	return ""
	
func previous_form()->Item:
	return null
	
func was_transformed_by_effect()->String:
	return ""
	
func sprite_path()->String:
	return ""
	
func apply_effect(_effect:String)->void:
	pass
	
func max_applications(_effect:String)->int:
	return 0

func attributes()->PackedStringArray:
	return [""]
####################################################################################################

func become_dropped(pos:Vector2)->void:
	var dropped_item = load("res://StoreComponent/Interactables/DroppedItem/DroppedItem.tscn").instantiate()
	dropped_item.init(self)
	dropped_item.position = pos
	Global.current_store.add_interactable(dropped_item)

func item_transformed()->void:
	#for i in get_children():
	#	queue_free()
	pass
	
func equals(_item:Item)->bool:
	if _item.a_name() == a_name():
		return true
	return false

func save():
	var save_dict = {
	}
	return save_dict
	
func _load(_node_data:Dictionary):
	pass
