extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var button_unpressed = preload("res://Sprites/UIpack_RPG/PNG/buttonLong_beige.png") 
var button_pressed = preload("res://Sprites/UIpack_RPG/PNG/buttonLong_beige_pressed.png") 
onready var datastore = get_tree().get_root().get_node("DataStore")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Level1.texture = button_unpressed
	$Level2.texture = button_unpressed
	pass # Replace with function bres://Sprites/UIpack_RPG/PNG/buttonLong_beige_pressed.pngody.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("move_left"):
		datastore.scene_number = 1
		get_tree().change_scene("res://Level2.tscn")
	if Input.is_action_pressed("move_right"):
		get_tree().change_scene("res://MainScene.tscn")
	if Input.is_action_pressed("move_down"):
		get_tree().change_scene("res://TheEnd.tscn")
	pass
