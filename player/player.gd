extends KinematicBody2D


#constant cant be change, 60 pixels per second speed
var speed = 60

#how many pixels are convered duriung jump
var jump_power = -250
const double_jump_power = -250
#rate of fall speed
var gravity = 10

var followup1 = false
#vari for dash controls
var dash_speed = 75
var dasher = false
var firefistignited = false
var fireball = false
var jump_counter = 0
var maxjumper = 1
var ghostin = false
var double_jumping = false
var jumping = false
var falling = false
var firefistanimation = false

#zero negative 1 is top of box, 0 one is top of box
const FLOOR = Vector2(0,-1)

const fireball = preload("res://player/moves/fireball/big/fireball-Area2D.tscn")
const fireballsmall = preload("res://player/moves/fireball/small/fireballsmall-Area2D.tscn")
const dash = preload("res://player/moves/dash/dash-Area2D.tscn")
const firefist = preload("res://player/moves/firefist/firefist-Area2D.tscn")

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
var right = true
var left = true

		
		
#character controls physics
func _physics_process(delta):
	
	if is_dead == false:
		
		
		if Input.is_action_pressed("ui_right") && right:
			if is_attacking == false || is_on_floor() == false:
				velocity.x = speed
				#double jumping equal false to cancel out run animation
				if !is_attacking && !double_jumping && !firefistignited:
					
					$AnimatedSprite.play("run")
					$AnimatedSprite.flip_h = false
					#fireball position
					if sign($Position2D.position.x) == -1:
						$Position2D.position.x *= -1
					#firefist position
					if sign($Position2D3.position.x) == -1:
						$Position2D3.position.x *= -1
					#the position where the animation occurs..the 2dcurson
					#dash animation
					if sign($Position2D2.position.x) == 1:
						$Position2D2.position.x *= -1
								# dash animation
#			if Input.is_action_just_pressed("ui_dash"):
#				#stop player from moving duting animation dash
#				velocity.x = 0
#				#dash animation play
#				$AnimatedSprite.play("dash")
#				is_attacking = true
#				self.position.x += dash_speed
#				var dashv = dash.instance()
#				#Dash direction normal or flipped
##				if sign($Position2D2.position.x) == 1:
##					dashv.set_dash_direction(1)
##				#add fireball to scene
#				get_parent().add_child(dashv)
##				#set position
#				dashv.position = $Position2D2.global_position

		elif Input.is_action_pressed("ui_left") && left:
			if is_attacking == false || is_on_floor() == false:
				velocity.x = -speed
				#double jumping equal false to cancel out run animation
				if is_attacking == false && double_jumping == false:
					
					$AnimatedSprite.play("run")
					$AnimatedSprite.flip_h = true
					#fireball position
					if sign($Position2D.position.x) == 1:
						$Position2D.position.x *= -1
					#firefist position
					if sign($Position2D3.position.x) == 1:
						$Position2D3.position.x *= -1
					#dash animation
					if sign($Position2D2.position.x) == -1:
						$Position2D2.position.x *= -1
								# dash animation
#			if Input.is_action_just_pressed("ui_dash") :
#				#stop player from moving duting animation dash
#				velocity.x = 0
#				#dash animation play
#				$AnimatedSprite.play("dash")
#				is_attacking = true
#				self.position.x += -dash_speed
#				var dashv = dash.instance()
#				#Dash direction of execution...not placement..to flip animation
#				#plays dash animation behind sprite in direction of execution
##				if sign($Position2D2.position.x) == 1:
##					dashv.set_dash_direction(-1)
#							#add fireball to scene
#				dashv.set_dash_direction(-1)
#				get_parent().add_child(dashv)
#				#set position
#				dashv.position = $Position2D2.global_position

		else:
			velocity.x = 0
			if on_ground == true && is_attacking == false:
				$AnimatedSprite.play("idle")
				
			
			#may notes for top down game
			#jump for side scroller
		if Input.is_action_pressed("ui_accept"):
			if is_attacking == false:
				if on_ground == true:
#					$AnimatedSprite.play("jump")
					velocity.y = jump_power
					on_ground = false
					jumping = true
					ghostin = false
					#jump_counter += 1
					$gravityTimer.start()
		
		#DOUBLE JUMP
		if Input.is_action_just_pressed("ui_accept"):
			if on_ground == false:
				if is_attacking == false:
					if maxjumper > jump_counter:
						velocity.y = double_jump_power
						ghostin = true
						jump_counter += 1
						double_jumping = true
						$gravityTimer.start()
#						$AnimatedSprite.play("flip")
						


		
		
		
		
		#tell if player is on the ground...
		
		if is_on_floor():
			if on_ground == false:
				is_attacking = false
			on_ground = true
			jump_counter = 0
			ghostin = false
			jumping = false
			double_jumping = false
			speed = 60
			gravity = 10

		else: #hes in the air
			if is_attacking == false:
				on_ground = false
				if velocity.y < 0 && maxjumper > jump_counter :
					$AnimatedSprite.play("jump")
				elif velocity.y < 0 && maxjumper <= jump_counter:
						$AnimatedSprite.play("flip")

			
				else :
					$AnimatedSprite.play("fall")
					double_jumping = false
		
		
		#FIREBALLKEY
		
		if Input.is_action_just_pressed("ui_focus_next") && is_attacking == false:
			fireball = true
			if is_on_floor() || on_ground == false:
				gravity = 1
				speed = 0
				velocity.y = 0
				
				falling = false
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
			$gravityTimer.start()
			
			
		#FIREFIST
		
		if Input.is_action_just_pressed("ui_firefist") && !firefistignited:
			ghostin = true
			firefistignited = true
			jump_power = 0
			speed = 10
			gravity = .5
			velocity.y = 0
			$gravityTimer.start()
			firefistanimation = true
			is_attacking = true
			$AnimatedSprite.play("punch1")
#			#create instance of fireball
			var firefistv = firefist.instance()
			firefistv.set_attack(0)
			#fireball directions of fire
			if sign($Position2D3.position.x) == 1:
				firefistv.set_firefist_direction(1)
			else:
				firefistv.set_firefist_direction(-1)
			#add fireball to scene
			get_parent().add_child(firefistv)
			#set position
			firefistv.position = $Position2D3.global_position
			$PunchTimer.start()
			
			
			if Input.is_action_just_pressed("ui_firefist") && followup1:
				ghostin = true
				firefistignited = true
				jump_power = 0
				speed = 10
				gravity = .5
				velocity.y = 0
				$gravityTimer.start()
				firefistanimation = true
				is_attacking = true
				$AnimatedSprite.play("punch2")
	#			#create instance of fireball
				var firefistv2 = firefist.instance()
				firefistv.set_attack(1)
				#fireball directions of fire
				if sign($Position2D3.position.x) == 1:
					firefistv.set_firefist_direction(1)
				else:
					firefistv2.set_firefist_direction(-1)
				#add fireball to scene
				get_parent().add_child(firefistv)
				#set position
				firefistv.position = $Position2D3.global_position
				
				followup1 = false
				$PunchTimer.stop()
				
				
			
#		if Input.is_action_just_released("ui_firefist"):
#			firefistanimation = false
			
			
			
		 #DASH 
		if Input.is_action_just_pressed("ui_dash"):
				#stop player from moving duting animation dash
				dasher = true
				speed = 0
				gravity = 1
				velocity.y = 0
				#dash animation play
				is_attacking = true
				$AnimatedSprite.play("dash")
				
				var dashv = dash.instance()
				#Dash direction normal or flipped
				if sign($Position2D2.position.x) == 1:
					dashv.set_dash_direction(-1)
					self.position.x -= dash_speed
				else:
					dashv.set_dash_direction(1)
					self.position.x += dash_speed
#				#add fireball to scene
				get_parent().add_child(dashv)
#				#set position
				dashv.position = $Position2D2.global_position
				$gravityTimer.start()
				
		# sprint dash
		if Input.is_action_just_pressed("sprint"):
			is_attacking = true
			speed = 4000
			velocity.y = 0
			velocity.x = speed
			dasher = true
			$AnimatedSprite.play("dasher")
			gravity = -1
			
			right = false
			left = false
			$dashtimer.start()
			


			
			
		if is_on_wall():
			velocity.x = 0
			
		velocity.y += gravity
			
			
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
	get_tree().change_scene("res://titlescreen.tscn")
	
func _on_ghost_Timer2_timeout():
	if ghostin == true:
		#make copy of ghost object..
		#create car ghost load ghost sceen. and create the ghost, instance creates copy of it
		var this_ghost = preload("res://ghostImage/ghost.tscn").instance()
		#give ghost parent
		get_parent().add_child(this_ghost)
		this_ghost.position = position
		#assinging snimated sprite thourgh code
		#seen on sprite
		#get frames, get current animation from current frame
		this_ghost.texture = $AnimatedSprite.frames.get_frame($AnimatedSprite.animation, $AnimatedSprite.frame)
		#face the same direction as main sprite
		this_ghost.flip_h = $AnimatedSprite.flip_h
		

		

	

func _on_AnimatedSprite_animation_finished():
	is_attacking = false

func _on_PunchTimer_timeout():
	followup1 = true
 

func _on_gravityTimer_timeout():
	if dasher || firefistignited || double_jumping || fireball:
		#set custom attacj parameters back to normal
		gravity = 10
		speed = 60
		dasher = false
		firefistignited = false
		jump_power = -250
		ghostin = false
		right = true
		left = true





func _on_dashtimer_timeout():
	if dasher || fireball:
		#set custom attacj parameters back to normal
		gravity = 10
		speed = 60
		dasher = false
		firefistignited = false
		jump_power = -250
		ghostin = false
		right = true
		left = true
