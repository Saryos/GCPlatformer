extends Popup


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var npc_name setget name_set
var dialogue setget dialogue_set
var answers setget answers_set

# Called when the node enters the scene tree for the first time.
func _ready():
	#set_process_input(false)
	dialogue = "Hello adventurer! I lost my necklace, can you find it for me?"
	answers = "[A] Yes  [B] No"
	dialogue_set(dialogue)
	answers_set(answers)
	open()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func name_set(new_value):
	npc_name = new_value
	$ColorRect/NPCName.text = new_value

func dialogue_set(new_value):
	dialogue = new_value
	$ColorRect/Dialogue.text = new_value

func answers_set(new_value):
	answers = new_value
	$ColorRect/Answers.text = new_value
	
func open():
	get_tree().paused = true
	#popup()
	call_deferred("popup")
	#$AnimationPlayer.playback_speed = 60.0 / dialogue.length()
	#$AnimationPlayer.play("ShowDialogue")
	set_process_input(true)
	
func close():
	get_tree().paused = false
	hide()
	
func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_A:
			set_process_input(false)
			#npc.talk("A")
		elif event.scancode == KEY_B:
			set_process_input(false)
			#npc.talk("B")
