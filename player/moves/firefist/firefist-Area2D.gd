extends Area2D
const speed = 100
var attack = 0
var velocity = Vector2()
var direction = 1

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func set_firefist_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true
		
func set_attack(attacknum):
	attack = attacknum
	
	if attacknum == 1:
		attack = 1
	else:
		attack = 0

#delta calculates the player speed into this function
func _physics_process(delta):
	velocity.x = 0
	translate(velocity)
	if attack == 0:
		$AnimatedSprite.play("firefist1")
	if attack == 1:
		$AnimatedSprite.play("firefist2")


func _on_firefistArea2D_body_entered(body):
	#checks if enemy exist in body name
	if "player" in body.name:
		pass
	if "Enemy" in body.name:
		body.dead()
	



func _on_AnimatedSprite_animation_finished():
	queue_free()
