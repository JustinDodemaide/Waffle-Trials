extends CharacterBody2D
class_name Player

@export var speed:int = 325
var immobile:bool = false

var carried_item:Item = null

var current_interactable:Interactable = null
#var current_employee:Employee = null
var options_menu = null
var option:String = ""

var request_menu = null

func _ready():
	pass

func _process(_delta):
	current_interactable = null
	#current_employee = null
	for i in $Area2D.get_overlapping_areas():
		if i.get_parent() is Interactable:
			current_interactable = i.get_parent()
			break
			
	if current_interactable != null:
		$Prompts/CurrentInteractable.visible = true
		$Prompts/CurrentInteractable.text = "\'E\' " + current_interactable.a_name()
		current_interactable.make_outline()
	else:
		$Prompts/CurrentInteractable.text = ""
		$Prompts/CurrentInteractable.visible = false
		if options_menu != null:
			options_menu.queue_free()
			options_menu = null
	#if current_employee != null:
	#	$Prompts/CurrentEmployee.visible = true
	#	$Prompts/CurrentEmployee.text = "\'R\' " + " tell " + current_employee.a_name() + " to make hashbrowns"
	#else:
	#	$Prompts/CurrentEmployee.visible = false
	#	$Prompts/CurrentEmployee.text = ""

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('D'):
		$AnimatedSprite2D.flip_h = false
		velocity.x += 1
	if Input.is_action_pressed('A'):
		$AnimatedSprite2D.flip_h = true
		velocity.x -= 1
	if Input.is_action_pressed('S'):
		velocity.y += 1
	if Input.is_action_pressed('W'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(_delta):
	get_input()
	if immobile:
		return
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")
	else:
		move_and_slide()
		$AnimatedSprite2D.play("move")
		if not $Footsteps.playing:
			$Footsteps.play_sound("footstep1")
			await $Footsteps.finished
			$Footsteps.play_sound("footstep2")
	
func immobilize(time:int)->void:
	immobile = true
	make_progress_bar(time)
	var timer = Timer.new()
	add_child(timer)
	timer.start(time)
	await timer.timeout
	immobile = false

func _input(event):
	if event.is_action_pressed("E"):
		if current_interactable != null:
			print("shulfjds")
			make_options_menu()
		else:
			print(current_interactable)
	#if event.is_action_pressed("R"):
	#	if request_menu == null:
	#		make_request_menu()
	#	else:
	#		remove_request_menu()
	if event.is_action_pressed("Z"):
		if carried_item != null:
			if carried_item.a_name() == "Anti-Skeleton Pan":
				drop_item()

func make_request_menu()->void:
	var menu = load("res://Level/Player/Request/RequestMenu.tscn").instantiate()
	menu.init()
	request_menu = menu
	request_menu.option_chosen.connect(request_option_chosen)
	add_child(menu)
	
func remove_request_menu()->void:
	if request_menu != null:
		request_menu.queue_free()
		
func request_option_chosen(_option:String):
	remove_request_menu()
	print(_option)
	var item = Global.new_item(_option)
	# supertask, option, interactable, required item, wait
	var heat_lamp = null
	for i in Global.current_store.get_node("Interactables").get_children():
		if i.a_name() == "Heat Lamp":
			if !i.is_full():
				heat_lamp = i
				break
	if heat_lamp == null:
		return
	var task = Task.new("production","deposit",heat_lamp,item)
	Global.current_store.add_ticket(task)

func make_options_menu()->void:
	if options_menu != null:
		options_menu.queue_free()
	options_menu = load("res://StoreComponent/OptionsMenu/Store_OptionsMenu.tscn").instantiate()
	options_menu.init(self)
	add_child(options_menu)
	
func make_employee_options_menu()->void:
	pass
	
func option_chosen(_option:String)->void:
	option = _option
	current_interactable.interact(self)
	options_menu.queue_free()
	
func carry_item(item:Item):
	if carried_item != null:
		drop_item()
	carried_item = item
	if carried_item.a_name() == "Plate": # hack
		$CarriedItem.add_child(carried_item.sprite())
	else:
		$CarriedItem.texture = load(item.sprite_path())
	if item.a_name() == "Anti-Skeleton Pan":
		$Prompts/DropItem.text = "\'Z\' Drop"
	$Sound.play_sound("pop")
	
func drop_item():
	if carried_item == null:
		return
	carried_item.become_dropped(position)
	remove_item()

func remove_item():
	$Prompts/DropItem.text = ""
	#carried_item.queue_free()
	if carried_item.a_name() == "Plate": # hack
		for i in $CarriedItem.get_children():
			i.queue_free()
	carried_item = null
	$CarriedItem.texture = null
	$Sound.play_sound("put")
	
func is_empty_handed()->bool:
	return carried_item == null
	
func make_progress_bar(time:float)->void:
	var bar = load("res://StoreComponent/Indicators/ProgressBar.tscn").instantiate()
	add_child(bar)
	bar.start(time)
	await bar.finished
	bar.queue_free()
	
func money_changed()->void:
	$Camera2D/Money.text = str(Global.money)

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y
	}
	print("save dict: ",save_dict["filename"])
	return save_dict

func _load(node_data:Dictionary):
	position.x = node_data["pos_x"]
	position.y = node_data["pos_y"]
