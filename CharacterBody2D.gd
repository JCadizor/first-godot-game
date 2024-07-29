extends CharacterBody2D


@export_range(1,10) var SPEED = 3
@export_range(0,1) var movementWeight = 0.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("ui_left", "ui_right","ui_up","ui_down")
	var targetVelocity = direction * SPEED * 100
	velocity = lerp(velocity, targetVelocity,movementWeight)

	move_and_slide()
