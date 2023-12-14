extends KinematicBody2D

onready var stunned_timer = $stunned_timer
var stunned = false
var health = 3
var velocity = Vector2.ZERO
var speed = 50
onready var player = get_parent().get_parent().get_node("player")
onready var navigation = get_node("NavigationAgent2D")
var attacking = false

func _physics_process(delta):
	if health <= 0:
		queue_free()
	if not stunned:
		if attacking:
			navigation.set_target_location(player.global_position)
			velocity = global_position.direction_to(navigation.get_next_location()) * speed
			navigation.set_velocity(velocity)
			look_at(navigation.get_next_location())
		
		move_and_slide(velocity)


func _on_VisibilityNotifier2D_screen_entered():
	attacking = true


func _on_stunned_timer_timeout():
	stunned = false
