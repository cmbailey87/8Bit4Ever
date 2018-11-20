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

func set_fireballsmall_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true
		

#delta calculates the player speed into this function
func _physics_process(delta):
	velocity.x = speed * delta * direction
	translate(velocity)
	$AnimatedSprite.play("shoot")


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_fireballsmallArea2D_body_entered(body):
	#checks if enemy exist in body name
	if "player" in body.name:
		pass
	else:
		queue_free()
	if "Enemy" in body.name:
		body.dead()
	
