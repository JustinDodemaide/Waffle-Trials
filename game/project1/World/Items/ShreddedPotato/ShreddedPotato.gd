extends Item

var grill_level:int = 0

func a_name()->String:
	return "ShreddedPotato"

func file_path()->String:
	return "res://World/Items/ShreddedPotato/ShreddedPotato.gd"

func previous_form()->Item:
	var item = load("res://World/Items/Item.tres").duplicate()
	item.init("Potato")
	return item

func was_transformed_by_effect()->String:
	return "cut"

func sprite_path()->String:
	return "res://World/Items/ShreddedPotato/ShreddedPotato.png"

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
			Global.play_sound("done")
			init("Hashbrowns")
