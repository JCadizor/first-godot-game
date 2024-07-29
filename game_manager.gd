extends Node

signal game_over

var time_survived: String
var monsters_defeated: int=0
var meat_counter:int =0
var current_time : float = 0.0
var time_elapsed_string: String

var player: Player
var player_position: Vector2
var is_game_over: bool = false


func _process(delta):
	current_time+= delta
	var seconds_enlapsed : int = floori(current_time)
	var seconds : int = seconds_enlapsed%60
	var minutes : int = seconds/60
	time_elapsed_string = "%02d:%02d" %[minutes,seconds]
	
func on_meat_collected(regenerated_value: int):
	meat_counter += regenerated_value/10
	
func end_game():
	if is_game_over: return
	is_game_over = true
	game_over.emit()
	
func reset():
	player=null
	player_position = Vector2.ZERO
	time_survived = "00:00"
	current_time =0.0
	monsters_defeated=0
	meat_counter =0
	is_game_over= false
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
	pass
