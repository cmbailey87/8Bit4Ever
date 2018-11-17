extends KinematicBody2D

#constant cant be change, 60 pixels per second
const speed = 60
const jump_power = -200
const gravity = 10

#zero negative 1 is top of box, 0 one is top of box
const FLOOR = Vector2(0,-1)


var on_ground = false

var velocity = Vector2()

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#func _ready():
#	# Called when the node is added to the scene for the first time.
#	# Initialization here
#	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

#character controls physics
func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = true
	else:
		velocity.x = 0
		if on_ground == true:
			$AnimatedSprite.play("idle")
		
		#may notes for top down game
		#jump for side scroller
	if Input.is_action_pressed("ui_up"):
		if on_ground == true:
			velocity.y = jump_power
			on_ground = false
	#elif Input.is_action_pressed("ui_down"):
	#	velocity.y = speed
	#else:
	#	velocity.y = 0
	
	
	velocity.y += gravity
	
	if is_on_floor():
		on_ground = true
	else: #hes in the air
		on_ground = false
		if velocity.y < 0:
			$AnimatedSprite.play("jump")
		else:
			$AnimatedSprite.play("fall")
	
	velocity = move_and_slide(velocity,FLOOR)
	
	
	