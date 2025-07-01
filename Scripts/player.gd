class_name Player extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const Y_LIMIT = 1000.0  # Arvo, jonka alle ei saa pudota
const RESET_POSITION = Vector2(0, 0)  # Minne hahmo palautetaan

func reset_to_start():
	global_position = Vector2(0, 0)
	velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_left"):
		$AnimatedSprite2D.scale.x = abs(scale.x)

		
	if Input.is_action_just_pressed("ui_right"):
		$AnimatedSprite2D.scale.x = abs(scale.x) * -1
		
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		$AnimatedSprite2D.play("run")
			
		velocity.x = direction * SPEED
		
	else:
		$AnimatedSprite2D.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if $AnimatedSprite2D.global_position.y < -1000:
		$AnimatedSprite2D.global_position = 0
		
	move_and_slide()
