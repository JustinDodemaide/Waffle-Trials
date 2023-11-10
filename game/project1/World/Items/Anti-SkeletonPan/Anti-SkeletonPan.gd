extends Item

var _level:int = 0

func a_name()->String:
	return "Anti-Skeleton Pan"

func file_path()->String:
	return "res://World/Items/Anti-SkeletonPan/Anti-SkeletonPan.gd"

func previous_form()->Item:
	return null

func was_transformed_by_effect()->String:
	return ""

func sprite_path()->String:
	return "res://World/Items/Anti-SkeletonPan/Anti-SkeletonPan.png"

func attributes()->PackedStringArray:
	return ["able",]

func max_applications(_effect:String)->int:
	return 0
func apply_effect(_effect:String)->void:
	if _effect == "":
		_level += 1
		if _level >= max_applications(""):
			init("")
