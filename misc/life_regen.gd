extends Node2D

@export   var regenaration_amount: int
@export var healing_effect: PackedScene
@onready var area2d: Area2D 

func _ready():
	$Area2D.body_entered.connect(on_body_entered)
	
	
func on_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		var player: Player = body
		player.heal(regenaration_amount)
		var new_effect= healing_effect.instantiate()
		GameManager.on_meat_collected(regenaration_amount)
		queue_free()
	print(body)
	pass
