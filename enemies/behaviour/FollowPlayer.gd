extends Node2D
var enemy: Enemy

@export_range(0.1, 5) var original_speed: float = 2
var player_position:Vector2 = position
var input_vector: Vector2 = Vector2.ZERO
var my_sprite: AnimatedSprite2D
var speed_damage_reduction: float = 0.7
var speed: float = original_speed

func _ready():
	enemy = get_parent()
	my_sprite = enemy.get_node("AnimatedSprite2D")
	pass

func _process(_delta):
	
	#ignorar game over
	if GameManager.is_game_over: return
	if input_vector.x != 0:
		if input_vector.x>0:
			my_sprite.flip_h =false
			pass
		else:
			my_sprite.flip_h =true
			pass

func _physics_process(_delta):
	#ignorar game over
	if GameManager.is_game_over: return
	
	var player_position = GameManager.player_position
	input_vector = (player_position - enemy.position).normalized()
	var speed: float = original_speed
	if enemy.damaged:
		speed *= speed_damage_reduction
	
	enemy.velocity = input_vector * speed * 100.0
	enemy.move_and_slide()
