extends TileMap
class_name Store

var scene_handler = null

var tickets:Dictionary = {}

# The busy-ness of the store goes up and down depending on how much time has elapsed.
# It starts average, then gets slow, then back to average, then fast.
# By using sin(frequency_factor * elapsed_time), we get a range of values that oscillates between 1 and -1. (takes 2.6 minutes to reach 1)
# 0 to 0.5 is low frequency, 0.5 to -0.5 is medium, and -0.5 to -1 is high
# The frequency is used to determine how often a customer spawns. During high frequency, a customer spawns every 5-10 seconds
var elapsed_time:int = 0
const customer_frequency_time_ranges = {"Low": [20,30], "Medium": [10,20], "Moderate":[10,12], "High": [3,7]}
const frequency_factor = 0.03 # Determines how rapidly the difficulty swings. The higher the value, the faster
var current_frequency:String

func enter(_msg := {}) -> void:
	#load_game()
	randomize()
	Global.current_store = self
	#for i in 5:
	#	var offset_x = randi_range(-5,5)
	#	var offset_y = randi_range(-5,5)
	#	make_dropped_item("Plate",Vector2(766 + offset_x,211+offset_y))
	make_dropped_item("Anti-SkeletonPan",Vector2(923,224))
	$SkeletonTimer.start(randi_range(30,120))
	make_customer()
	$CustomerTimer.start(randi_range(5,10))
	Global.money_changed.connect(money_changed)
	Global.world.world_clock.timeout.connect(second_passed)

func exit() -> void:
	pass
	#save_game()

#func _ready():

func _input(event):
	#if event.is_action_pressed("M"):
	#	get_parent().transition_to("res://WorldMap/WorldMap.tscn")
	if event.is_action_pressed("1"):
		pass
		#make_customer()
	if event.is_action_pressed("2"):
		pass
		#lose_life()
		#make_skeleton()

func _process(_delta):
	pass
	#$Tickets.text = ""
	#for key in tickets:
	#	for i in tickets[key]:
	#		$Tickets.text += str(i) + "\n"

func a_name():
	return "Store"

func make_dropped_item(item_name:String,pos:Vector2)->void:
	var item:Item = Global.new_item(item_name)
	var dropped_item = load("res://StoreComponent/Interactables/DroppedItem/DroppedItem.tscn").instantiate()
	dropped_item.init(item)
	dropped_item.position = pos
	add_interactable(dropped_item)

func add_interactable(interactable:Interactable)->void:
	$Interactables.add_child(interactable)

func add_ticket(task:Task)->void:
	if tickets.has(task.supertask):
		tickets[task.supertask].append(task)
	else:
		var arr:Array[Task] = [task]
		tickets[task.supertask] = arr

func remove_ticket(task:Task)->void:
	tickets[task.supertask].erase(task)

func get_ticket(supertask:String)->Task:
	if !tickets.has(supertask):
		return null
	if tickets[supertask].is_empty():
		return null
	for ticket in tickets[supertask]:
		if ticket.being_done_by == null:
			return ticket
	return null
	
func find_interactable_with_item(item:Item)->Interactable:
	#print("interactables ", $Interactables.get_children())
	for i in $Interactables.get_children():
		if i.has(item):
			return i
	return null

func find_producer_of_item(item:Item)->Interactable:
	for i in $Interactables.get_children():
		if i.effect() == item.was_transformed_by_effect():
			return i
	return null

func make_customer():
	var customer = load("res://StoreComponent/Customers/Customer.tscn").instantiate()
	customer.level = self
	var positions = [Vector2(-697,522),Vector2(2016,537)]
	var start_position = positions[randi_range(0,1)]
	customer.position = start_position
	customer.get_node("CharacterBody2D").position = start_position
	customer.visible = false
	#customer.get_node("AnimatedSprite2D").position = Vector2(2016,537)
	#customer.get_node("Area2D").position = Vector2(2016,537)
	add_child(customer)

func is_reachable(pos:Vector2)->bool:
	var tile_coord = local_to_map(pos)
	var cell_data = get_cell_tile_data(0, tile_coord)
	if cell_data == null:
		return false
	return cell_data.get_custom_data("reachable")

func get_exit()->Vector2:
	var exits = [Vector2(-35,8),Vector2(2016,537)]
	return exits[randi_range(0,1)]
	
func second_passed():
	elapsed_time += 1
	var freq = sin(frequency_factor * elapsed_time)
	if freq >= 0 and freq < 0.5:
		current_frequency = "Low"
	if freq >= 0.5:
		current_frequency = "Medium"
	if freq < 0 and freq >= -0.5:
		current_frequency = "Moderate"
	if freq < -0.5:
		current_frequency = "High"
	$UI/Frequency.text = current_frequency + " frequency"
	#print("frequency: ",freq, ", ", current_frequency)
	
func _on_skeleton_timer_timeout():
	make_skeleton()
	$SkeletonTimer.start(randi_range(30,120))

func make_skeleton():
	var skeleton = load("res://StoreComponent/Skeleton/Skeleton.tscn").instantiate()
	skeleton.level = self
	skeleton.position = Vector2(811, 408)
	add_child(skeleton)
	
func _on_customer_timer_timeout():
	make_customer()
	
	var freq_range = customer_frequency_time_ranges[current_frequency]
	#var time = randi_range(freq_range.front(),freq_range.back())
	var time = freq_range.front()
	print("spawning customer in ", freq_range.front(), "-", freq_range.back(), " seconds (", time,")")
	$CustomerTimer.start(time)
	
func money_changed(_amount)->void:
	$Sound.play_sound("money")
	$UI/Money.text = "$" + str(Global.money)

func lose_life():
	var lives = $UI/Lives.get_children()
	$Sound.play_sound("LoseLife")
	lives.front().lose_life()
	if lives.size() == 1:
		print("lost")
		Global.emit_signal("lost")
