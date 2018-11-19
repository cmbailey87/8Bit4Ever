extends Area2D
const speed = 100
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

func set_fireball_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true
		

#delta calculates the player speed into this function
func _physics_process(delta):
	velocity.x = speed * delta * direction
	translate(velocity)
	$AnimatedSprite.play("shoot")



func _on_VisibilityNotifier2D_screen_exited():
	#destroys the object...no more mem
	queue_free()


func _on_fireballarea2d_body_entered(body):
	#velocity.x = 0
	#AnimatedSprite.play("splat")
	queue_free()
	
