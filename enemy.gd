extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 50
onready var player = get_parent().get_parent().get_node("player")
onready var navigation = get_node("NavigationAgent2D")

func _physics_process(delta):
	
	
	
	navigation.set_target_location(player.global_position)
	velocity = global_position.direction_to(navigation.get_next_location()) * speed
	navigation.set_velocity(velocity)
	look_at(navigation.get_next_location())
	
	move_and_slide(velocity)
