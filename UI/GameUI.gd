extends CanvasLayer

@onready var meat_label: Label =%Meat_Label
@onready var gold_label: Label =%Gold_Label
@onready var timer_label: Label =%Time_Label

func _process(delta):
	timer_label.text = GameManager.time_elapsed_string
	meat_label.text = str(GameManager.meat_counter)
