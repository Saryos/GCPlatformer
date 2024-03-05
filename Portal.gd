extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var datastore = get_tree().get_root().get_node("DataStore")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Portal_body_entered(body):
	datastore.scene_number += 1
	get_tree().change_scene(datastore.scenes[datastore.scene_number])
	pass # Replace with function body.
