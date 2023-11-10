extends Item

var _level:int = 0

func a_name()->String:
	return "Empty Box"

func file_path()->String:
	return "res://World/Items/EmptyBox/EmptyBox.gd"

func previous_form()->Item:
	return null

func was_transformed_by_effect()->String:
	return ""

func sprite_path()->String:
	return "res://World/Items/EmptyBox/EmptyBox.png"

func attributes()->PackedStringArray:
	return ["disposeable",]

func max_applications(effect:String)->int:
	return 0
func apply_effect(_effect:String)->void:
	pass
