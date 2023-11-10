extends Interactable

func _ready():
	#await Global.world_ready
	pass
	#Global.world.world_clock.timeout.connect(_on_timer_timeout)

func _process(_delta):
	$Label.text = ""
	for i in storage:
		$Label.text += i.a_name() + "\n"

func a_name()->String:
	return "Oven"

func max_storage()->int:
	return 3

func effect()->String:
	return "heat"

func effect_strength()->int:
	return 1

func deposit_attributes()->PackedStringArray:
	return ["heatable"]

func _on_timer_timeout():
	apply_effect()
