extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var back1 = preload("res://Background/title/cloudsinthedesert.png")
onready var back2 = preload("res://Background/title/coldmountain.png")
onready var back3 = preload("res://Background/title/sunsetintheswamp.png")
onready var back4 = preload("res://Background/title/wizardtower.png")

onready var background = [back1, back2, back3, back4]

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var sound_number = rng.randi_range(0, 3)
	$CanvasLayer/Background.texture = background[sound_number]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
