extends Node

var game_over:bool

func _ready():
	Global.lost.connect(game_lost)

func _input(event):
	if game_over:
		return
	if event.is_action_pressed("Escape"):
		print("escape2")
		get_tree().paused = not get_tree().paused
		$CanvasLayer/Paused.visible = not $CanvasLayer/Paused.visible
		
func game_lost():
	game_over = true
	$Sound.play_sound("game_over")
	get_tree().paused = true
	
	var best_score = get_best_score()

	$CanvasLayer/GameOver.visible = true
	var size_tween1 = create_tween()
	size_tween1.tween_property($CanvasLayer/GameOver,"scale",Vector2(2,2),0.25).set_ease(Tween.EASE_IN)
	await size_tween1.finished
	
	var size_tween2 = create_tween()
	size_tween2.tween_property($CanvasLayer/GameOver,"scale",Vector2(1,1),0.5).set_trans(Tween.TRANS_BOUNCE)
	await size_tween2.finished
	
	$CanvasLayer/VBoxContainer/Score.text = "Score: " + str(Global.money)
	$CanvasLayer/VBoxContainer/BestScore.text = "Best Score: " + str(best_score)
	
	$CanvasLayer/VBoxContainer.visible = true
	#var color_tween1 = create_tween()
	#color_tween1.tween_property($CanvasLayer/VBoxContainer,"modulate",Color(255,255,255,255),4)
	
	if Global.money > best_score:
		save_score()
		$CanvasLayer/VBoxContainer/NewBest.visible = true
		
	$CanvasLayer/VBoxContainer/PlayAgain.visible = true
	$CanvasLayer/VBoxContainer/EndGame.visible = true

func save_score()->void:
	var text_file = FileAccess.open("user://score.save", FileAccess.WRITE)
	if text_file == null:
		return
	if not text_file.is_open():
		return

	var string = JSON.stringify({"score":Global.money})
	print("Save string ", string)
	text_file.store_string(string)
	text_file.close()
	
func get_best_score()->int:
	if not FileAccess.file_exists("user://score.save"):
		print("file doesnt exist")
		return -1 # Error! We don't have a save to load.

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://score.save", FileAccess.READ)
	#while save_file.get_position() < save_file.get_length():
	var line = save_file.get_line()
	# Get the data from the JSON object
	var score_dict:Dictionary = JSON.parse_string(line)
	return score_dict["score"]


func _on_play_again_pressed():
	$"../SceneHandler".transition_to("res://Level/Level.tscn")
	$CanvasLayer/GameOver.visible = false
	$CanvasLayer/VBoxContainer.visible = false
	$CanvasLayer/VBoxContainer/NewBest.visible = false
	$CanvasLayer/VBoxContainer/PlayAgain.visible = false
	$CanvasLayer/VBoxContainer/EndGame.visible = false
	Global.money = 0
	get_tree().paused = false


func _on_end_game_pressed():
	get_tree().quit()
