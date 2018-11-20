extends KinematicBody2D

var is_dead = false

const gravity = 10
#made this negative so he could walk left in the starting animation...
const speed = 30
#so godot knows where to detect the floor
const FLOOR = Vector2(0,-1)

#default 00
var velocity = Vector2()

#track the srpite direction
var direction = 1

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func dead():
	is_dead = true
	velocity = Vector2(0,0)
	$AnimatedSprite.play("dead")
	$CollisionShape2D.disabled = true	
	$Timer.start()
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _physics_process(delta):
	#check if alive
	if is_dead == false:
		velocity.x = speed * direction
		if direction == 1:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
			
		$AnimatedSprite.play("walk")
		velocity.y += gravity
		velocity = move_and_slide(velocity, FLOOR)
	
	#if wall is detected, change direction of velocity to negative
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
		
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1

func _on_Timer_timeout():
	queue_free()
