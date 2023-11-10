extends Item

func a_name()->String:
	return "Bagel"

func file_path()->String:
	return "res://World/Items/Bagel/Bagel.gd"

func previous_form()->Item:
	return null

func was_transformed_by_effect()->String:
	return ""

func sprite_path()->String:
	return "res://World/Items/Bagel/Bagel.png"

func attributes()->PackedStringArray:
	return [""]

func max_applications(effect:String)->int:
	return 0
