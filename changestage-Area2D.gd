extends Area2D

#exporting string variable...
#key work file is hint, tell editor, UI functions to search for file
#type of file that is tscn extention
#assingned to variable target stage

export(String, FILE, "*.tscn") var target_stage

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_changestageArea2D_body_entered(body):
	if "player" in body.name:
		get_tree().change_scene(target_stage)
