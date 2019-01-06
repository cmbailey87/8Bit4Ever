extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	#kinda the property of the tween, interprolate....
	#interprolate on what object self.. modulate property..(initial value) 0color full to transparent (final value).. time of .6 seconds
	#what kinda easing...then easin out or both
	$alpha_Tween.interpolate_property(self,"modulate", Color(1,1,1,1),Color(1,1,1,0), .6, Tween.TRANS_SINE, Tween.EASE_OUT)
	$alpha_Tween.start()
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_alpha_Tween_tween_completed(object, key):
	queue_free()
