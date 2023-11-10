extends Node2D

var level:Store

@onready var current_task = Task.new("","collect",null)
var leaving:bool = false
var dead:bool = false
var moving:bool = true
var target:Interactable = null
var carried_item:Item = null
#func _init(i_supertask:String,i_option:String,i_interactable:Interactable,i_required_item:Item = null,wait:float = 0.0):
func a_name():
	return "Skeleton"

func _ready():
	var lamp = level.get_node("Interactables").get_node("HeatLamp")
	if not lamp.is_empty():
		target = lamp
		$NavigationAgent2D.set_target_position(lamp.position)
		return
	lamp = get_parent().get_node("Interactables").get_node("HeatLamp2")
	if not lamp.is_empty():
		target = lamp
		$NavigationAgent2D.set_target_position(lamp.position)
		return
		
	var options:Array[Interactable] = []
	for i in get_parent().get_node("Interactables").get_children():
		if i.a_name().contains("Box"):
			options.append(i)
	randomize()
	target = options[randi_range(0,options.size()-1)]
	$NavigationAgent2D.set_target_position(target.position)

func _on_navigation_agent_2d_target_reached():
	if leaving:
		queue_free()
	else:
		if not target.is_interaction_valid(self):
			_ready()
			return
		moving = false
		$AnimatedSprite2D.play("grab")
		await $AnimatedSprite2D.animation_finished
		moving = true
		target.interact(self)
		check_pan()
		leave()

func leave():
	leaving = true
	$NavigationAgent2D.set_target_position(get_parent().get_exit())
	$AnimatedSprite2D.play("move")
	
func _physics_process(_delta: float) -> void:
	if not dead and moving:
		move($NavigationAgent2D.get_next_path_position())

func move(destination):
	#print("moving to: ", destination)
	
	var character_body = $CharacterBody2D
	if destination.x < position.x:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	character_body.velocity = (destination - character_body.position).normalized() * 120
	#$AnimatedSprite2D.play("move")
	character_body.move_and_slide()
	position = character_body.position

func _on_area_2d_area_entered(area):
	if dead:
		return
	if area.get_parent() is Player or area.get_parent() is Employee:
		var character = area.get_parent()
		if character.carried_item == null:
			return
		if character.carried_item.a_name() == "Anti-Skeleton Pan":
			die()

func die():
	$Sound.play_sound("pan")
	if carried_item != null:
		drop_item()
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("die")
	dead = true
	var tween = create_tween()
	var new_mod = Color(255,255,255,0)
	tween.tween_property(self,"modulate",new_mod,4)
	await tween.finished
	queue_free()
		
func carry_item(item:Item):
	if carried_item != null:
		drop_item()
	if item == null:
		return
	carried_item = item
	$CarriedItem.texture = load(item.sprite_path())
	
func drop_item():
	if carried_item == null:
		return
	carried_item.become_dropped(position)
	carried_item = null
	$CarriedItem.texture = null

func check_pan():
	if carried_item == null:
		return
	if carried_item.a_name() == "Anti-Skeleton Pan":
		#die()
		for i in range(12):
			Global.current_store.make_skeleton()
			await Global.world.world_clock.timeout
		var tween = create_tween()
		tween.tween_interval(8)
		await tween.finished
		Global.current_store.make_dropped_item("Anti-SkeletonPan",Vector2(923,224))
