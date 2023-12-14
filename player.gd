extends KinematicBody2D

onready var hearts : TextureRect = $CanvasLayer/hearts
var can_switch = false
var strength = .01
var velocity = Vector2.ZERO
var max_speed = 75
var friction = 10
var acceleration = 10
var health = 5
var can_attack = true
var invicible = false
var last_collision: KinematicCollision2D
var pushback = Vector2.ZERO
var pushback_strength = 80

func _physics_process(delta):
	
	hearts.rect_size.x = health * 22
	
	if Input.is_action_just_pressed("interact") and can_switch:
		if Global.lights_out:
			Global.lights_out = false
		else:
			Global.lights_out = true
		
	var direction = Input.get_vector("move_left" , "move_right" , "move_up" , "move_down")
	
	if direction == Vector2.ZERO:
		velocity = velocity.move_toward(Vector2.ZERO, friction)
	else:
		velocity += direction * acceleration
		velocity = velocity.limit_length(max_speed)
		
	pushback = pushback.move_toward(Vector2.ZERO, friction)
		
	velocity += pushback
	
	look_at(get_global_mouse_position())
	move_and_slide(velocity)
	
	last_collision = get_last_slide_collision()
	if last_collision and last_collision.collider.is_in_group("Enemies"):
		pushback = last_collision.normal * pushback_strength
	
	if Input.is_action_just_pressed("attack"):
		can_attack = false
		attack()


func attack():
	pass
	

func set_invincible(status=true):
	# toggle invicible flag 
	invicible = status
	# toggle flash character
	if status:
		$AnimationPlayer.play("Flash")
	else:
		$AnimationPlayer.play("RESET")
	# toggle collision with enemies
	set_collision_mask_bit(2, not status)
	set_collision_layer_bit(0, not status)
	
	$InvincibilityTimer.start()
	

func _on_Area2D_body_entered(body):
	if not invicible:
		health -= 1
		set_invincible(true)
		
#	var direction = (body.global_position - global_position).normalized()
#	var velocity_in_direction = velocity.dot(direction)
#	body.global_position += velocity_in_direction * -direction * strength


func _on_InvincibilityTimer_timeout():
	set_invincible(false)
