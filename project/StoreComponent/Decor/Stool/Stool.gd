extends StaticBody2D

var taken:bool = false

func _process(_delta):
	if taken:
		$Label.text = "taken"
	else:
		$Label.text = "not taken"
