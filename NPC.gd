extends KinematicBody2D

#onready var text = get_node("Text")
onready var player = get_tree().get_root().get_node("MainScene/Player")
# state of dialogue
var state = -1
var old_state = -2
# are we ready for next selection?
var selected = false
onready var speak = $SpeachBubble

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("select"):
		if state > -1 && !selected:
			selected = true
			state += 1
	if !Input.is_action_pressed("select"):
		selected = false
		
	if state != old_state:
		old_state = state
		_speak(state)
	
func _speak(state):
	match state:
		0:
			speak.say("!!!!!!!")
		1:
			speak.say("You can never jump to the top of that cliff!")
		2:
			speak.say("At least not without help")
		3:
			pass
			speak.say("My brother left his double jump shoes, I guess he won't need them anymore. I can sell them to you.")
		4:
			#text.text = "DoubleJump Boots (30 coins)"
			player.set_doublejump(1)
			
func _on_Trigger_body_entered(body):
# called when we collide with a physics body
	if body.name != "Player":
		return
	state += 1
	
