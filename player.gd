extends KinematicBody2D


#constant cant be change, 60 pixels per second speed
const speed = 60

#how many pixels are convered duriung jump
const jump_power = -250
const double_jump_power = -300
#rate of fall speed
const gravity = 10

#vari for dash controls
var dash_speed = 200
var max_speed = 300
var dasher = false

var jump_counter = 0
var maxjumper = 1
var ghostin = false



var state = 0

#zero negative 1 is top of box, 0 one is top of box
const FLOOR = Vector2(0,-1)

const fireball = preload("res://fireball-Area2D.tscn")
const fireballsmall = preload("res://fireballsmall-Area2D.tscn")
const dash = preload("res://dash-Area2D.tscn")

#boolean flag for being on the ground
var on_ground = false

var is_attacking = false

var velocity = Vector2()

var is_dead = false



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
	
	if is_dead == false:
		
		
		if Input.is_action_pressed("ui_right"):
			if is_attacking == false || is_on_floor() == false:
				velocity.x = speed
				dasher = true
				if is_attacking == false:
					$AnimatedSprite.play("run")
					$AnimatedSprite.flip_h = false
					#fireball position
					if sign($Position2D.position.x) == -1:
						$Position2D.position.x *= -1
					#the position where the animation occurs..the 2dcurson
					if sign($Position2D2.position.x) == 1:
						$Position2D2.position.x *= -1
								# dash animation
			if Input.is_action_just_pressed("ui_dash") && dasher == true:
				#stop player from moving duting animation dash
				if is_on_floor():
					velocity.x = 0
				#dash animation play
				$AnimatedSprite.play("fireshot")
				is_attacking = true
				self.position.x += 100
				var dashv = dash.instance()
				#Dash direction normal or flipped
				if sign($Position2D2.position.x) == 1:
					dashv.set_dash_direction(1)
							#add fireball to scene
				get_parent().add_child(dashv)
				#set position
				dashv.position = $Position2D2.global_position
				

		elif Input.is_action_pressed("ui_left"):
			if is_attacking == false || is_on_floor() == false:
				velocity.x = -speed
				if is_attacking == false:
					$AnimatedSprite.play("run")
					$AnimatedSprite.flip_h = true
					#fireball position
					if sign($Position2D.position.x) == 1:
						$Position2D.position.x *= -1
					if sign($Position2D2.position.x) == -1:
						$Position2D2.position.x *= -1
								# dash animation
			if Input.is_action_just_pressed("ui_dash") && dasher == true:
				#stop player from moving duting animation dash
				if is_on_floor():
					velocity.x = 0
				#dash animation play
				$AnimatedSprite.play("fireshot")
				is_attacking = true
				self.position.x += -100
				var dashv = dash.instance()
				#Dash direction of execution...not placement..to flip animation
				#plays dash animation behind sprite in direction of execution
				if sign($Position2D2.position.x) == 1:
					dashv.set_dash_direction(-1)
							#add fireball to scene
				get_parent().add_child(dashv)
				#set position
				dashv.position = $Position2D2.global_position

		else:
			velocity.x = 0
			if on_ground == true && is_attacking == false:
				$AnimatedSprite.play("idle")
				state = 0
				
			
			#may notes for top down game
			#jump for side scroller
		if Input.is_action_pressed("ui_accept"):
			if is_attacking == false:
				if on_ground == true:
#					$AnimatedSprite.play("jump")
					velocity.y = jump_power
					on_ground = false
					#jump_counter += 1
					state = 2
		
		#DOUBLE JUMP
		if Input.is_action_just_pressed("ui_accept"):
			if on_ground == false:
				if is_attacking == false:
					if maxjumper > jump_counter:
						velocity.y = double_jump_power
						ghostin = true
						jump_counter += 1
						state = 3
#						$AnimatedSprite.play("doublejump")


		
		
		velocity.y += gravity
		
		#tell if player is on the ground...
		
		if is_on_floor():
			if on_ground == false:
				is_attacking = false
			on_ground = true
			jump_counter = 0
			ghostin = false
		else: #hes in the air
			if is_attacking == false:
				on_ground = false
				if velocity.y < 0 && maxjumper > jump_counter :
					$AnimatedSprite.play("flip")
				elif velocity.y < 0 && maxjumper <= jump_counter:
						$AnimatedSprite.play("flip")

			
				else :
					$AnimatedSprite.play("fall")
		
		
		#FIREBALLKEY
		
		if Input.is_action_just_pressed("ui_focus_next") && is_attacking == false:
			if is_on_floor() || on_ground == false:
				velocity
			is_attacking = true
			$AnimatedSprite.play("fireshot")
			#create instance of fireball
			var fireballv = fireballsmall.instance()
			#fireball directions of fire
			if sign($Position2D.position.x) == 1:
				fireballv.set_fireballsmall_direction(1)
			else:
				fireballv.set_fireballsmall_direction(-1)
			#add fireball to scene
			get_parent().add_child(fireballv)
			#set position
			fireballv.position = $Position2D.global_position
			

				

			
		if is_on_wall():
			velocity.x = 0
			
		
			
			
		#move and slide function allows the player to move about the level
		#
		velocity = move_and_slide(velocity,FLOOR)
		
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Enemy" in get_slide_collision(i).collider.name:
					dead()
	
		
func dead():
	is_dead = true
	velocity = Vector2(0,0)
	$AnimatedSprite.play("dead")
	$CollisionShape2D.disabled = true
	$Timer.start()

	






func _on_Timer_timeout():
	get_tree().change_scene("titlescreen.tscn")
	
func _on_ghost_Timer2_timeout():
	if ghostin == true:
		#make copy of ghost object..
		#create car ghost load ghost sceen. and create the ghost, instance creates copy of it
		var this_ghost = preload("res://ghost.tscn").instance()
		#give ghost parent
		get_parent().add_child(this_ghost)
		this_ghost.position = position
		#assinging snimated sprite thourgh code
		#seen on sprite
		#get frames, get current animation from current frame
		this_ghost.texture = $AnimatedSprite.frames.get_frame($AnimatedSprite.animation, $AnimatedSprite.frame)
		#face the same direction as main sprite
		this_ghost.flip_h = $AnimatedSprite.flip_h
		

		
func _on_dash_timer_timeout():
	$AnimatedSprite.position.x = 0
	

func _on_AnimatedSprite_animation_finished():
	is_attacking = false


