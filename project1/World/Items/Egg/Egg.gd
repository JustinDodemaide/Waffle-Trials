extends Item

var cut_level:int = 0
var grill_level:int = 0

func a_name()->String:
	return "Egg"

func file_path()->String:
	return "res://World/Items/Egg/Egg.gd"

func previous_form()->Item:
	return null

func was_transformed_by_effect()->String:
	return ""

func sprite_path()->String:
	return "res://World/Items/Egg/Egg.png"

func attributes()->PackedStringArray:
	return ["grillable",]

func max_applications(effect:String)->int:
	if effect == "cut":
		return 1
	if effect == "grill":
		return 10
	return 0
func apply_effect(_effect:String)->void:
	if _effect == "cut":
		cut_level += 1
		if cut_level >= max_applications("cut"):
			init("CrackedEgg")
	if _effect == "grill":
		grill_level += 1
		if grill_level >= max_applications("grill"):
			init("ScrambledEggs")
