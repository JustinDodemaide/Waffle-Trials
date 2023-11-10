extends Node
class_name Character

var current_level:WorldObject = null

var alive:bool = true
var max_health:int = 1
var health:int = max_health

func a_name()->String:
	return "Character"
	
func character_sprite()->String:
	return ""

func change_health(amount:int)->void:
	health += amount
	if health <= 0:
		health = 0
		alive = false
