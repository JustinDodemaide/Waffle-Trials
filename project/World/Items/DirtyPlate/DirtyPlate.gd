extends Item

var wash_level:int = 0

func a_name()->String:
	return "Dirty Plate"

func file_path()->String:
	return "res://World/Items/DirtyPlate/DirtyPlate.gd"

func previous_form()->Item:
	return null

func was_transformed_by_effect()->String:
	return ""

func sprite_path()->String:
	return "res://World/Items/DirtyPlate/DirtyPlate.png"

func attributes()->PackedStringArray:
	return ["washable",]

func max_applications(effect:String)->int:
	if effect == "wash":
		return 5
	return 0
func apply_effect(_effect:String)->void:
	if _effect == "wash":
		wash_level += 1
		if wash_level >= max_applications("wash"):
			init("Plate")
