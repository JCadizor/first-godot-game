class_name Player
extends CharacterBody2D

@export_range(0,10) var default_speed: float= 5
@export_range(0,10) var speed_attack_move_mult: float =  0.2
@export_range(0,1) var lerp_control: float =0.9
@export_category("Sword")
@export_range(1,10) var sword_damage: int = 1
@export_category("Magic")
@export var spell1: PackedScene
@export var spell1_damage:int = 2
@export_category("Life")
@export var max_health:int = 10
@export var health = 10
@export var death_prefab: PackedScene 


@onready var player_sprite: Sprite2D = $Player_sprite
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitBoxArea
@onready var healthBar: ProgressBar = $HealthProgressBar

var is_running: bool = false
var was_running: bool = false
var is_attaking: bool = false
var default_attack_cooldown = 0.6
var attack_cooldown = default_attack_cooldown
var hitbox_cooldown: float = 0.0
var spell_cooldown: float = 0.0
var speed = default_speed
var rng = RandomNumberGenerator.new()
var input_vector: Vector2 = Vector2.ZERO
var attack_vector = Vector2.ZERO


func _ready():
	GameManager.player = self
	healthBar.max_value = max_health
	
	

func _process(delta: float):
	#ignorar game over
	if GameManager.is_game_over: return
	GameManager.player_position = position
	update_hitbox_detection(delta)
	update_spell(delta)
	#update healthbar
	healthBar.value = health
	
	if is_attaking:	
		attack_cooldown -= delta
		if attack_cooldown <=0.0:
			is_attaking = false
			speed = default_speed
			if is_running:
				animation_player.play("Run")
			else:
				animation_player.play("Idle")
	
	# actualizar o is running
	was_running= is_running;
	is_running = not input_vector.is_zero_approx()
	
	if not is_attaking:
		if was_running != is_running:
			if is_running:
				animation_player.play("Run")
			else:
				animation_player.play("Idle")
	
# flip sprite
	flipSprite ()
	

# ataque
	if Input.is_action_just_pressed("attack"):
		attack(input_vector)

func _physics_process(_delta):
	input_vector = Input.get_vector("move_left","move_right","move_up","move_down",0.10)
		
	var target_velocity = input_vector *speed*  100
	if is_attaking:
		target_velocity *= speed_attack_move_mult
	velocity = lerp(velocity, target_velocity, lerp_control)
	move_and_slide()
	
	
		
func attack(input_vector: Vector2):
	if is_attaking:
		return
# new attack
	is_attaking = true
	attack_cooldown = default_attack_cooldown
	attack_vector = input_vector.normalized()
	#print_debug("input_vector X:"+str(input_vector.x)+"\n input_vector Y:"+ str(input_vector.y))
	if abs(input_vector.x)>= abs(input_vector.y):
		animation_player.play("Attack_side_1")
		if player_sprite.flip_h:
			attack_vector = Vector2.RIGHT
		else:
			attack_vector = Vector2.LEFT
		#print_debug("just attaked"+str(input_vector))
	else :
		if input_vector.y < 0:
			animation_player.play("Attack_up_1")
			attack_vector = Vector2.UP
		elif input_vector.y > 0:
			animation_player.play("Attack_down_1")
			attack_vector = Vector2.DOWN
	
func dealDamageToEnemies():
	#buscar todos os enimigos e aplicar o base damage
	var areas = sword_area.get_overlapping_areas()
	for area in areas:
		if area.get_parent().is_in_group("enemies"):
			var enemy: Enemy=area.get_parent()
			var direction_to_enemy =(position - enemy.position).normalized()
			var attack_direction = attack_vector
			var dot_direction = direction_to_enemy.dot(attack_direction)
			print(dot_direction)
			if dot_direction > 0:
				print("hit an enemy")
				enemy.damage_health(sword_damage)
		pass
	#var enemies_in_scnene = get_tree().get_nodes_in_group("enemies")
	#print("enemies :",enemies_in_scnene.size())
	#for enemy in enemies_in_scnene:
		#
		#pass

func update_spell(delta: float) -> void:
	spell_cooldown -= delta
	if spell_cooldown > 0: return
	print("spell cooldown: ",spell_cooldown)
	spell_cooldown = 30
	var spell = spell1.instantiate()
	spell.damage_amount = spell1_damage
	add_child(spell)
	pass

func update_hitbox_detection (delta: float):
	#temporizar a hitbox
	hitbox_cooldown -= delta
	if hitbox_cooldown >0:return
		
	#frequência de dano (2 x segundos)
	hitbox_cooldown = 0.5
	
	#HitboxArea
	
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			damage_health(enemy.damage_dealt)
	pass

func flipSprite():
	if not is_attaking:
		if input_vector.x != 0:
			if input_vector.x>0:
				player_sprite.flip_h =false
				pass
			else:
				player_sprite.flip_h =true
				pass
	pass
func damage_health(amount: int):
	
	if health <= 0:
		return
	health-= amount
	#print("Recebi ",amount," de dano\n","tenho ",health,"/",max_health," de vida")
	#levar dano
	modulate = Color.DARK_RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate",Color.WHITE,0.1)

	
	#preocessar morte
	if health <= 0:
		die ()
	pass
	
func heal(amount: int) -> int:
	health+=amount
	if health > max_health:
		health = max_health
	print("next health",health)
	return health
func die():
	GameManager.end_game()	
	if death_prefab:
		var death_animation_effect = death_prefab.instantiate()
		death_animation_effect.position = position
		get_parent().add_child(death_animation_effect)
	queue_free()
	print ("Player Morreu!")
	pass
