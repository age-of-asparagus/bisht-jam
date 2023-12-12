extends KinematicBody2D

var strength = .01
var velocity = Vector2.ZERO
var speed = 300
var can_attack = true

func _physics_process(delta):
	
	
	
	velocity = Input.get_vector("move_left" , "move_right" , "move_up" , "move_down") * speed
	
	look_at(get_global_mouse_position())
	
	move_and_slide(velocity)
	
	
	if Input.is_action_just_pressed("attack"):
		can_attack = false
		attack()




func attack():
	pass


func _on_Area2D_body_entered(body):
	var direction = (body.global_position - global_position).normalized()
	var velocity_in_direction = velocity.dot(direction)
	body.global_position += velocity_in_direction * -direction * strength
