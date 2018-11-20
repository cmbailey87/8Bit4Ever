extends Node2D

#so low priority dont cancel out high priority screen shake
var current_shake_priority = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func move_camera(vector):
	get_parent().get_node("player").get_node("Camera2D").offset = Vector2(rand_range(-vector.x, vector.x), rand_range(-vector.y, vector.y) )


func screen_shake(shake_length, shake_power, shake_priority):
	if shake_priority > current_shake_priority:
		current_shake_priority = shake_priority
		#tween has function method, 
		#self mean look inside current current script for resources for functions methods..called move camera
		#
		#tween node will calculate inbetweens for 2 different values...1-10 finds 2-9 , like smooth animation program tweening
		#current shake lenth 1 power 10, priority 100
		$Tween.interpolate_method(self, "move_camera", Vector2(shake_power, shake_power), Vector2(0,0) , shake_length,Tween.TRANS_SINE,Tween.EASE_OUT,0 )
		$Tween.start()




func _on_Tween_tween_completed(object, key):
	current_shake_priority = 0
