extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():

	$MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus()
	


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _physics_process(delta):
	if $MarginContainer/VBoxContainer/VBoxContainer/TextureButton.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus()
	if $MarginContainer/VBoxContainer/VBoxContainer/TextureButton2.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/TextureButton2.grab_focus()

	
#startgame button
func _on_TextureButton_pressed():
	get_tree().change_scene("stageone.tscn")

#exit the game
func _on_TextureButton2_pressed():
	get_tree().quit()
