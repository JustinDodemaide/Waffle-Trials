extends Item

var grill_level:int = 0

func a_name()->String:
	return "Sliced Bread"

func file_path()->String:
	return "res://World/Items/SlicedBread/SlicedBread.gd"

func previous_form()->Item:
	var item = load("res://World/Items/Item.tres").duplicate()
	item.init("Bread")
	return item

func was_transformed_by_effect()->String:
	return "cut"

func sprite_path()->String:
	return "res://World/Items/SlicedBread/SlicedBread.png"

func attributes()->PackedStringArray:
	return ["grillable",]

func max_applications(effect:String)->int:
	if effect == "grill":
		return 5
	return 0
func apply_effect(_effect:String)->void:
	if _effect == "grill":
		grill_level += 1
		if grill_level >= max_applications("grill"):
			init("Toast")
