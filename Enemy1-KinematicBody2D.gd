extends KinematicBody2D

var is_dead = false

const gravity = 10
#made this negative so he could walk left in the starting animation...
#const speed = 30
#retire




#so godot knows where to detect the floor
const FLOOR = Vector2(0,-1)

#default 00
var velocity = Vector2()

#export int, variable that is editable in the inspector
export(int) var speed = 30 

#hp create an HP variable
export(int) var hp = 1

#size variable
export(Vector2) var size = Vector2(1,1)


#track the srpite direction
var direction = 1

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	scale = size
	pass
	
func dead():
	hp -= 1 
	if hp <= 0:
		is_dead = true
		#velocity = Vector2(0,0)
		$AnimatedSprite.play("dead")
		$CollisionShape2D.scale = Vector2(1.7,1.3)
		
		$CollisionShape2D.disabled = true
		
		
		$Timer.start()
		if scale > Vector2(1,1):
			#parent node is hte stage node, screenshake is childnode, scren_shake is function in childnode
			#screenshake of lenth, power, prority
			get_parent().get_node("screenshake").screen_shake(1,10,100)


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
	
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			if "player" in get_slide_collision(i).collider.name:
				get_slide_collision(i).collider.dead()

func _on_Timer_timeout():
	queue_free()
