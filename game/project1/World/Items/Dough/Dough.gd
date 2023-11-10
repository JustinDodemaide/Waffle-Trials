extends Item

var decomposition_level:int = 0
var heat_level:int = 0

func a_name()->String:
	return "Dough"
	
func file_path()->String:
	return "res://World/Items/Dough/Dough.gd"
	
func previous_form()->Item:
	return null
	
func was_transformed_by_effect()->String:
	return ""

func sprite_path()->String:
	return "res://World/Items/Dough/dough.png"
	
func attributes()->PackedStringArray:
	return ["heatable","freezable"]
	
func max_applications(effect:String)->int:
	if effect == "heat":
		return 5
	return 0
	
func apply_effect(_effect:String)->void:
	if _effect == "freeze":
		decomposition_level -= 5
		if decomposition_level < 0:
			decomposition_level = 0
	if _effect == "heat":
		heat_level += 1
		if heat_level >= 1:
			print("bread ready")
			init("Bread")
	if _effect == "exposure":
		decomposition_level += 1
		#if decomposition_level >= 20:
			

#func item_transformed()->void:
#	Global.world.world_clock.timeout.connect(timeout)
	
#func timeout()->void:
#	decomposition_level += 1
