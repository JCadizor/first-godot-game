extends Node2D

@onready var area: Area2D = $area_damage
@export var damage_amount: int = 1

func deal_damage():
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			body.damage_health(damage_amount)
	pass
