extends KinematicBody2D

#constant cant be change, 60 pixels per second speed
const speed = 60
#how many pixels are convered duriung jump
const jump_power = -250
const double_jump_power = -250
#rate of fall speed
const gravity = 10

var double_jump_enabled = false
var double_jump_counter = 0

#zero negative 1 is top of box, 0 one is top of box
const FLOOR = Vector2(0,-1)

const fireball = preload("res://fireball-Area2D.tscn")
const fireballsmall = preload("res://fireballsmall-Area2D.tscn")

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
				if is_attacking == false:
					$AnimatedSprite.play("run")
					$AnimatedSprite.flip_h = false
					if sign($Position2D.position.x) == -1:
						$Position2D.position.x *= -1
		elif Input.is_action_pressed("ui_left"):
			if is_attacking == false || is_on_floor() == false:
				velocity.x = -speed
				if is_attacking == false:
					$AnimatedSprite.play("run")
					$AnimatedSprite.flip_h = true
					if sign($Position2D.position.x) == 1:
						$Position2D.position.x *= -1
		else:
			velocity.x = 0
			if on_ground == true && is_attacking == false:
				$AnimatedSprite.play("idle")
			
			#may notes for top down game
			#jump for side scroller
		if Input.is_action_pressed("ui_accept"):
			if is_attacking == false:
				if on_ground == true:
					velocity.y = jump_power
					on_ground = false
					#double_jump_enabled = true
					double_jump_counter = 1
		#elif Input.is_action_pressed("ui_down"):
		#	velocity.y = speed
		#else:
		#	velocity.y = 0
		
		#DOUBLE JUMP
		if Input.is_action_just_pressed("ui_accept"):
			if is_attacking == false:
				if on_ground == false:
					#if double_jump_enabled == true:
					if double_jump_counter > 0 :
						velocity.y = double_jump_power
						on_ground = false
						#double_jump_enabled = false
						double_jump_counter = 0
		
		
		
		#FIREBALLKEY
		
		if Input.is_action_just_pressed("ui_focus_next") && is_attacking == false:
			if is_on_floor():
				velocity.x = 0
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
		
		velocity.y += gravity
		
		if is_on_floor():
			if on_ground == false:
				is_attacking = false
			on_ground = true
		else: #hes in the air
			if is_attacking == false:
				on_ground = false
				if velocity.y < 0:
					$AnimatedSprite.play("jump")
				else:
					$AnimatedSprite.play("fall")
		
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


func _on_AnimatedSprite_animation_finished():
	is_attacking = false


func _on_Timer_timeout():
	get_tree().change_scene("titlescreen.tscn")
