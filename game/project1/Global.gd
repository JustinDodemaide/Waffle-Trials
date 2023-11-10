extends Node

signal world_ready

var world

var money:float = 0.0
signal money_changed(amount)

var current_store:Store

signal lost

func has_intersection(array1,array2)->bool:
	for i in array1:
		if array2.has(i):
			return true
	return false

func new_item(item_name:String)->Item:
	var item = load("res://World/Items/Item.tres").duplicate()
	item.init(item_name)
	return item

func make_sprite(path:String)->Sprite2D:
	var sprite = Sprite2D.new()
	sprite.texture = load(path)
	return sprite
	
func add_money(amount:int)->void:
	money += amount
	emit_signal("money_changed",amount)

func make_indicator(position:Vector2,type:String,time:float = -1):
	var indicator = load("res://StoreComponent/Indicators/Indicator.tscn").instantiate()
	if time == -1:
		indicator.init(position,type)
	else:
		indicator.init(position,type,time)

func play_sound(sound:String):
	var s = load("res://sounds/Sound.tscn").instantiate()
	world.add_child(s)
	s.play_sound(sound,true)
	
