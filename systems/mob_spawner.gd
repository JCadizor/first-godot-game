class_name MobSpawner
extends Node2D

@export var creatures : Array[PackedScene]
@export var spawns_per_minute : float = 60.0
@onready var path_follow2d: PathFollow2D = %PathFollow2D

var cooldown: float =0.0
func _process(delta: float):
	#ignorar game over
	if GameManager.is_game_over: return
	
	# spawn cooldown
	cooldown -= delta
	if cooldown > 0: return
	# frequencia mosnter/minute
	var interval = 60.0/spawns_per_minute
	cooldown = interval
	#instancia uma criatura
	
	#validar um ponto no mundo
	var point= get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask = 0b1001
	var result:Array = world_state.intersect_point(parameters, 1)
	if not result.is_empty(): return
		
	
	var index = randi_range(0,creatures.size()-1)
	var new_mob = creatures[index]
	var creature = new_mob.instantiate()
	creature.global_position =get_point()
	get_parent().add_child(creature)
	pass

func get_point() -> Vector2:
	path_follow2d.progress_ratio = randf()
	return path_follow2d.global_position
	
