extends Interactable
class_name Customer

var level:Store

var seat

var order:Array[Item] = []
var order_complexity:int
var wait_time:int
var order_display = null
var plate:Item = null

var happy_with_service:bool = false

enum {MOVING_TO_SEAT,WAITING_FOR_ORDER,WAITING_TO_BE_SERVED,EATING,LEAVING}
var state:int = 0

signal seated
signal order_taken
signal order_served
signal done_eating

func a_name()->String:
	return "Customer"

func _ready():
	state = MOVING_TO_SEAT
	move_to_seat()
	visible = true # quick fix for visual bug I couldn't figure out
	await seated
	position = seat.position + seat.get_meta("seat")
	seat.taken = true
	$Sound.play_sound("chime")
	$AnimatedSprite2D.play("sit")
	generate_order()
	wait_to_be_served()
	await order_served
	$Timer.stop()
	give_money()
	eat()
	await done_eating
	leave()

func move_to_seat():
	state = MOVING_TO_SEAT
	for i in level.get_node("Seating").get_children():
		if not i.taken:
			seat = i
			i.taken = true
			$NavigationAgent2D.set_target_position(i.position)
			return
	print("No seating available!")
	leave()
#Task.new(task.supertask,"deposit",producer,task.required_item.previous_form())
func wait_for_order():
	state = WAITING_FOR_ORDER
	#level.add_ticket(Task.new("serving","use",self))
	$Timer.start(90)
	make_progress_bar(90)

func generate_order():
	var num_items:int = randi_range(1,3)
	for i in num_items:
		var val = randi_range(0,3)
		var item = Item.new()
		if val == 0:
			item.init("Waffle")
			order_complexity += 2
			wait_time += 20
		if val == 1:
			item.init("ScrambledEggs")
			order_complexity += 3
			wait_time += 25
		#if val == 2:
		#	item.init("Hashbrowns")
		#	order_complexity += 3
		#	wait_time += 25
		#if val == 3:
		#	item.init("Toast")
		#	order_complexity += 2
		if val == 2:
			item.init("Bagel")
			order_complexity += 1
			wait_time += 10
		if val == 3:
			item.init("Coffee")
			order_complexity += 1
			wait_time += 12
		order.append(item)
	make_order_display()
	#level.add_ticket(task())

#func task()->Task:
#	return Task.new("production", "use",self,order)

func wait_to_be_served():
	state = WAITING_TO_BE_SERVED
	#level.add_ticket(Task.new("serving","deposit",self,order))
	print("wait time: ", wait_time)
	$Timer.start(wait_time)
	make_progress_bar(wait_time)
	
#func judge_order():
#	var correct_items:int = 0
#	for i in order.items:
#		for j in plate.items:
#			if i.equals(j):
#				correct_items += 1
#				break
#	if correct_items == order.items.size():
#		Global.add_money(10)
#		eat()
#	else:
#		var p = Global.new_item("Plate")
#		p.become_dropped(position)
#		leave()

func eat():
	state = EATING
	remove_progress_bar()
	$Timer.start(2)
	await $Timer.timeout
	#drop_dirty_plate()
	emit_signal("done_eating")

func drop_dirty_plate():
	var dp = Global.new_item("DirtyPlate")
	dp.become_dropped(position)
	var sink = level.get_node("Interactables").get_node("Sink")
	#level.add_ticket(Task.new("custodial","deposit",sink,Global.new_item("DirtyPlate")))

func leave():
	if state == WAITING_TO_BE_SERVED:
		Global.current_store.lose_life()
	
	state = LEAVING
	remove_progress_bar()
	$Timer.stop()
	if order_display != null:
		order_display.queue_free()
	if seat != null:
		seat.taken = false
	$AnimatedSprite2D.play("move")
	$NavigationAgent2D.set_target_position(level.get_exit())
	
func is_interaction_valid(interactor)->bool:
	var option = get_option(interactor)
	if option != "deposit":
		return false
	if interactor.carried_item == null:
		return false
	for item in order:
		if interactor.carried_item.a_name() == item.a_name():
			return true
	return false

#	if option != "use":
#		return false
#	if state == WAITING_TO_BE_SERVED:
#		if interactor.carried_item == null:
#			return false
#		if interactor.carried_item.a_name() != "Plate":
#			return false
#	return true
	
	
func interact(interactor)->void:
	if interactor.carried_item == null:
		return
	for item in order:
		if interactor.carried_item == null: # The first check wasn't working for some reason
			return
		if interactor.carried_item.a_name() == item.a_name():
			order.erase(item)
			interactor.remove_item()
			if order.is_empty():
				remove_order_display()
				if $Timer.time_left >= (wait_time / 2):
					happy_with_service = true
				$Timer.stop()
				emit_signal("order_served")
				return
			make_order_display()
			restore_time()
				

func restore_time():
	remove_indicator()
	var half_wait:float = wait_time / 2
	var time_left = $Timer.time_left
	if $Timer.time_left >= half_wait:
		$Timer.stop()
		$Timer.start(wait_time)
		make_progress_bar(wait_time)
	else:
		$Timer.stop()
		$Timer.start(half_wait)
		make_progress_bar(half_wait,wait_time)

func give_money():
	var amount = 10
	if happy_with_service:
		amount += order_complexity
	Global.add_money(amount)
	
#	if state == WAITING_FOR_ORDER:
#		$Timer.stop()
#		emit_signal("order_taken")
#		return
#	if state == WAITING_TO_BE_SERVED:
#		$Timer.stop()
#		order_display.queue_free()
#		plate = interactor.carried_item
#		interactor.remove_item()
#		emit_signal("order_served")

func _physics_process(_delta: float) -> void:
	if state == WAITING_TO_BE_SERVED:
		if indicator == null:
			if round($Timer.time_left) == round(wait_time / 3):
				$Sound.play_sound("warning")
				make_indicator()
	
	$Label.text = ""
	var string = ""
	if state == MOVING_TO_SEAT:
		string += "MOVING TO SEAT"
	if state == WAITING_FOR_ORDER:
		string += "WAITING FOR ORDER"
	if state == WAITING_TO_BE_SERVED:
		string += "WAITING TO BE SERVED"
	if state == EATING:
		string += "EATING"
	$Label.text = string
	if state == MOVING_TO_SEAT or state == LEAVING:
		move($NavigationAgent2D.get_next_path_position())

func move(destination):
	#print("moving to: ", destination)
	var character_body = $CharacterBody2D
	if destination.x < position.x:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	character_body.velocity = (destination - character_body.position).normalized() * 175
	#$AnimatedSprite2D.play("move")
	character_body.move_and_slide()
	position = character_body.position

var pb:ProgressBar = null
func make_progress_bar(time:float,max:float = -1):
	remove_progress_bar()
	pb = load("res://StoreComponent/Indicators/ProgressBar.tscn").instantiate()
	add_child(pb)
	pb.start(time)
	if max != -1:
		pb.start_partial(time,max)

func remove_progress_bar():
	if pb != null:
		pb.queue_free()
		
func make_order_display():
	remove_order_display()
	order_display = load("res://StoreComponent/Customers/OrderDisplay/OrderDisplay.tscn").instantiate()
	order_display.init(order)
	add_child(order_display)
	
func remove_order_display():
	if order_display == null:
		return
	order_display.queue_free()

func _on_timer_timeout():
	if state == LEAVING:
		return
	leave()
	
func make_outline()->void:
	pass

var indicator = null
func make_indicator():
	remove_indicator()
	indicator = load("res://StoreComponent/Indicators/Indicator.tscn").instantiate()
	indicator.init(position+Vector2(-28,0),"warning",3)

func remove_indicator():
	if indicator!=null:
		indicator.queue_free()

func _on_navigation_agent_2d_target_reached():
	if state == MOVING_TO_SEAT:
		emit_signal("seated")
		return
	if state == LEAVING:
		queue_free()
