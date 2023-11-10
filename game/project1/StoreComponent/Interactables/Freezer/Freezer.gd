extends Interactable

# REMEMBER TO CONNECT TIMER (IF NEEDED)

func a_name()->String:
	return "Freezer"

func max_storage()->int:
	return 3

func effect()->String:
	return "freeze"

func effect_strength()->int:
	return 1

func deposit_attributes()->PackedStringArray:
	return ["freezable"]

func _process(_delta):
	$Label.text = ""
	for i in storage:
		$Label.text += i.a_name()

