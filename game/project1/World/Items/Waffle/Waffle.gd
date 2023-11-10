extends Item

var waffle_level:int = 0

func a_name()->String:
	return "Waffle"

func file_path()->String:
	return "res://World/Items/Waffle/Waffle.gd"

func previous_form()->Item:
	var item = load("res://World/Items/Item.tres").duplicate()
	item.init("WaffleBatter")
	return item

func was_transformed_by_effect()->String:
	return "waffle"

func sprite_path()->String:
	return "res://World/Items/Waffle/Waffle.png"

func attributes()->PackedStringArray:
	return ["waffleable","plateable"]

func max_applications(effect:String)->int:
	if effect == "waffle":
		return 10
	return 0
func apply_effect(_effect:String)->void:
	if _effect == "waffle":
		waffle_level += 1
		if waffle_level >= max_applications("waffle"):
			Global.play_sound("rubbish")
			init("Rubbish")
