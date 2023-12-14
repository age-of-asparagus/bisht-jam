extends KinematicBody2D
onready var enemy_detector = $EnemyDetector

var Spit = preload("res://attack_particles.tscn")
var attack_rate = .75
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
	
	
	$attack_box/CollisionShape2D.disabled = true
	
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
	print(global_rotation_degrees)
	move_and_slide(velocity)
	
	if not invicible:
		for i in get_slide_count():
			var collision = get_slide_collision(i)
#			print(collision, collision.collider)
			
			# Could be colliding with wall, so only worry about Enemy collisions
			if collision.collider.is_in_group("Enemies"):
				# Hit by an enemy if it reaches here:
				pushback += collision.normal * pushback_strength
				
				# Only do this once per frame, in case hit by more than one enemy in a frame
				if not invicible:
					get_hurt()
		# Deal with glitch where player gets pinned against wall by enemies
		# but only collides with wall
		if get_slide_count() == 1 and get_slide_collision(0).collider is TileMap:
			# Check if also overlapping an enemy
			if enemy_detector.get_overlapping_bodies():
				get_hurt()
			
	if Input.is_action_just_pressed("attack"):
		if can_attack:
			$attack_rate.start(attack_rate)
			can_attack = false
			attack()
	

func get_hurt():
	health -= 1
	if health <= 0:
		get_tree().change_scene("res://StartMenu.tscn")
	set_invincible(true)
	$AudioStreamPlayer.play()


func attack():
#	var spit = Spit.instance()
#	spit.emitting = true
#	spit.global_position = $spit_spawn.global_position
#	get_parent().add_child(spit)
	$attack_particles.restart()
	$attack_box/CollisionShape2D.disabled = false
	

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
	

#func _on_Area2D_body_entered(body):
#	if not invicible:
#
#		print(last_collision)
##	var direction = (body.global_position - global_position).normalized()
##	var velocity_in_direction = velocity.dot(direction)
##	body.global_position += velocity_in_direction * -direction * strength


func _on_InvincibilityTimer_timeout():
	set_invincible(false)


func _on_attack_box_body_entered(body):
	body.got_hit()
	$attack_box/CollisionShape2D.disabled = true


func _on_attack_rate_timeout():
	can_attack = true


func _on_enemy_detector_body_exited(body):
	body.attacking = true
