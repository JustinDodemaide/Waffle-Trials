extends Item

var waffle_level:int = 0

func a_name()->String:
	return "Waffle Batter"

func file_path()->String:
	return "res://World/Items/WaffleBatter/WaffleBatter.gd"

func previous_form()->Item:
	return null

func was_transformed_by_effect()->String:
	return ""

func sprite_path()->String:
	return "res://World/Items/WaffleBatter/WaffleBatter.png"

func attributes()->PackedStringArray:
	return ["waffleable",]

func max_applications(effect:String)->int:
	if effect == "waffle":
		return 10
	return 0
func apply_effect(_effect:String)->void:
	if _effect == "waffle":
		waffle_level += 1
		if waffle_level >= max_applications("waffle"):
			Global.play_sound("done")
			init("Waffle")
