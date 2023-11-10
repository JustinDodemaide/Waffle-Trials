extends Item

var cut_level:int = 0

func a_name()->String:
	return "Bread"

func file_path()->String:
	return "res://World/Items/Bread/Bread.gd"

func previous_form()->Item:
	return null

func was_transformed_by_effect()->String:
	return ""

func sprite_path()->String:
	return "res://World/Items/Bread/Bread.png"

func attributes()->PackedStringArray:
	return ["cuttable",]

func max_applications(effect:String)->int:
	if effect == "cut":
		return 1
	return 0
func apply_effect(_effect:String)->void:
	if _effect == "cut":
		cut_level += 1
		if cut_level >= max_applications("cut"):
			init("SlicedBread")
