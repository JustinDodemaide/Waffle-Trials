extends CharacterBody2D
class_name Employee

var character:Character = null

var carried_item:Item = null
@export var speed: int = 300
var supertask:String = "production"

var tasks:Array[Task] = []
var current_task:Task = null
var waiting:bool = false

var moving:bool = false

func _ready():
	call_deferred("actor_setup")
	actor_setup()
	
func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	# Now that the navigation map is no longer empty, set the movement target.
	$NavigationAgent2D.set_target_position(position)
	
func init(c:Character):
	character = c

func a_name()->String:
	#return "Keith"
	return "Chip"
	#return character.a_name()
	
func carry_item(item:Item):
	if carried_item != null:
		drop_item()
	carried_item = item
	$CarriedItem.texture = load(item.sprite_path())
	
func drop_item():
	if carried_item == null:
		return
	carried_item.become_dropped(position)
	carried_item = null
	$CarriedItem.texture = null

func remove_item():
	#carried_item.queue_free()
	carried_item = null
	$CarriedItem.texture = null

func _process(_delta):
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")
	$Label.text = $StateMachine.state.name
	$TasksLabel.text = ""
	for i in tasks:
		$TasksLabel.text += str(i) + "\n"

func move_to(pos:Vector2)->void:
	$NavigationAgent2D.set_target_position(pos)
	moving = true

func add_task(task:Task):
#	print("")
	#print("add_task | ", task)
	task.being_done_by = self
	tasks.push_back(task)
	if task.option == "deposit":
		if carried_item != null:
			if carried_item.equals(task.required_item):
				# if they already have the item they need, go deposit the item
				get_next_task()
				return
			# if they dont have the item they need, go get it
		var new_task = Task.new(task.supertask,"collect",null,task.required_item)
		add_task(new_task)
		return
		# they're not carrying the required item, check if there's one somewhere in the level
	if task.option == "collect":
		var level = get_parent().get_parent()
		var item_location = level.find_interactable_with_item(task.required_item)
		if item_location != null:
			# if the item is somewhere in the level, go get it
			task.interactable = item_location
			get_next_task()
			return
		# if the item isn't already in the level, find somewhere they can produce it
		var producer:Interactable = level.find_producer_of_item(task.required_item)
		if producer != null:
			# if they find a place to produce it, go to that producer with the item required to make it
			task.interactable = producer
			var wait_time = ((task.required_item.previous_form().max_applications(producer.effect())) / producer.effect_strength()) + 1
			# wait time = (item.max_applications(interactble.effect) / interactable.effect_time) + safety
			var use = Task.new(task.supertask,"use",producer,producer.required_item(),wait_time)
			use.being_done_by = self
			var deposit = Task.new(task.supertask,"deposit",producer,task.required_item.previous_form())
			tasks.push_back(use)
			add_task(deposit)
			return
	if task.option == "use":
		# if an interactable requires a specific item to be used, collect that item
		if task.required_item != null:
			var new_task = Task.new(task.supertask,"collect",null,task.required_item)
			add_task(new_task)
			return
	# if the function reaches this point, there's no way to do the task
	print("task not possible, aborting")
	abort_tasks()
	
func get_next_task():
	#print("tasks: ", tasks)
	if tasks.is_empty():
		$StateMachine.transition_to("Wandering")
		return
	print("")
	print("getting next task")
	current_task = tasks.pop_back()
	print("task is: ", current_task)
	print("current task: ", current_task)
	if current_task == null:
		abort_tasks()
	if not current_task.interactable.is_interaction_valid(self):
		print("task is not valid")
		#print(current_task, " not valid")
		# abort, drop all tasks
		abort_tasks()
		$StateMachine.transition_to("Wandering")
		return
	$NavigationAgent2D.set_target_position(current_task.interactable.position)
	#print(current_task.interactable.a_name(), " position is ", current_task.interactable.position)
	$StateMachine.transition_to("Moving")
	#current_task.interactable.moved.connect()

func abort_tasks():
	print("tasks being aborted")
	if tasks.is_empty():
		return
	tasks.front().being_done_by = null
	tasks.clear()
	drop_item()
	current_task = null
	$StateMachine.transition_to("Wandering")

func _on_navigation_agent_2d_target_reached():
	if current_task != null:
		if current_task.interactable == null:
			abort_tasks()
			return
		print("target reached, ", current_task)
		print("interacting...")
		current_task.interactable.interact(self)
		if current_task.wait_time > 0:
			print("wait time: ", current_task.wait_time)
			print("waiting")
			$StateMachine.transition_to("Waiting",{"wait time": current_task.wait_time})
			await $StateMachine/Waiting.done_waiting
			print("done waiting")
		print("interaction done")
		if tasks.is_empty():
			get_parent().get_parent().remove_ticket(current_task)
			current_task = null
	get_next_task()
	
func is_empty_handed()->bool:
	return carried_item == null

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
