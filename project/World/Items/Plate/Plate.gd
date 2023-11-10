extends Item

var items:Array[Item] = []

func max_items()->int:
	return 3

const item_positions:PackedVector2Array = [Vector2(0,-2),Vector2(-7,5),Vector2(7,5)]
func add_item(item:Item)->void:
	assert(items.size() < max_items(),"Trying to add item to full plate")
	items.append(item)

func full()->bool:
	return items.size() == max_items()


func a_name()->String:
	return "Plate"

func file_path()->String:
	return "res://World/Items/Plate/Plate.gd"

func previous_form()->Item:
	return null

func was_transformed_by_effect()->String:
	return ""

func sprite()->Sprite2D:
	var plate = Sprite2D.new()
	plate.texture = load("res://World/Items/Plate/EmptyPlate.png")
	const positions:PackedVector2Array = [Vector2(0,-5),Vector2(-7,2),Vector2(7,2)]
	var i:int = 0
	for item in items:
		var s = Sprite2D.new()
		s.scale = Vector2(0.5,0.5)
		s.texture = load(item.sprite_path())
		s.position = positions[i]
		plate.add_child(s)
		i += 1
	return plate
	
func sprite_path()->String:
	return "res://World/Items/Plate/EmptyPlate.png"

func attributes()->PackedStringArray:
	return ["servable",]
