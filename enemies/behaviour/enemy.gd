class_name Enemy
extends Node2D

@export_category("Life")
@export var max_health:int = 3
@export var death_prefab: PackedScene 
@onready var health = max_health
@onready var damage_effect_position: Marker2D = $DamageSpawn
var damaged = false
var damage_dealt = 1
var damage_ui_effect_prefab: PackedScene

@export_category("Drops")
@export var base_drop_chance: float=0.1
@export var drop_items_set: Array[PackedScene]
@export var drop_chances:Array[float]

func _ready():
	damage_ui_effect_prefab =preload("res://misc/visual_fx/damage_digit.tscn")

func damage_health(amount: int):
	if health <= 0:
		return
	health-= amount
	damaged = true
	print("Recebi ",amount," de dano\n","tenho ",health,"/",max_health," de vida")
	#levar dano
	modulate = Color.DARK_RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate",Color.WHITE,0.1)

	#criar damage digit
	var damage_effect = damage_ui_effect_prefab.instantiate()
	damage_effect.value = amount
	if damage_effect_position:
		damage_effect.position = damage_effect_position.global_position
	else :  
		damage_effect.position = global_position
	get_parent().add_child(damage_effect)
	#preocessar morte
	if health <= 0:
		die ()
	pass
	
func die():
	if death_prefab:
		var death_animation_effect = death_prefab.instantiate()
		death_animation_effect.position = position
		get_parent().add_child(death_animation_effect)
		
		#drop
		if base_drop_chance <=randf():
			drop_item()
		
		#@export var drop_chance: float=0.1
		#@export var drop_items_set: Array[PackedScene]
	# increment monsters defeated
	GameManager.monsters_defeated +=1
	#delete node
	queue_free()
	pass

func drop_item():
	var drop = get_random_drop_item().instantiate()
	drop.position = position
	get_parent().add_child(drop)
	pass
func get_random_drop_item() -> PackedScene:
	if drop_items_set.size() == 1 : return drop_items_set[0]
	
	var max_chance: float =0
	for drop_chance in drop_chances:
		max_chance += drop_chance
		
	var chance_value = randf_range(0,max_chance)
	
	var selector:float = 0.0
	for i in drop_items_set.size():
		var drop_item = drop_items_set[i]
		var drop_chance = drop_chances[i] if i < drop_chances.size() else 1
		if chance_value <= drop_chance + selector:
			return drop_item
		selector += drop_chance
		
	return drop_items_set[0]
	#var droped_item = drop_items_set[randi_range(0,drop_items_set.size())].instantiate()
