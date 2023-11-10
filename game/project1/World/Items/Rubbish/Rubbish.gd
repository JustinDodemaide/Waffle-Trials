extends Item

var dispose_level:int = 0

func a_name()->String:
	return "Rubbish"

func file_path()->String:
	return "res://World/Items/Rubbish/Rubbish.gd"

func previous_form()->Item:
	return null

func was_transformed_by_effect()->String:
	return ""

func sprite_path()->String:
	return "res://World/Items/Rubbish/Rubbish.png"

func attributes()->PackedStringArray:
	return ["disposeable",]

func max_applications(effect:String)->int:
	if effect == "dispose":
		return 1
	return 0
func apply_effect(_effect:String)->void:
	if _effect == "dispose":
		dispose_level += 1
		if dispose_level >= max_applications("dispose"):
			init("")
