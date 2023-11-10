extends Item

var exposure_level:int = 0

func a_name()->String:
	return "Coffee"

func file_path()->String:
	return "res://World/Items/Coffee/Coffee.gd"

func previous_form()->Item:
	return null

func was_transformed_by_effect()->String:
	return ""

func sprite_path()->String:
	return "res://World/Items/Coffee/Coffee.png"

func attributes()->PackedStringArray:
	return ["plateable",]

func max_applications(effect:String)->int:
	if effect == "exposure":
		return 10
	return 0
func apply_effect(_effect:String)->void:
	if _effect == "exposure":
		exposure_level += 1
		if exposure_level >= max_applications("exposure"):
			init("Rubbish")
