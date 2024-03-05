extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var text = ""
var pop_speed : float = 1 #anim speed
var pop_size : float = 0 #current size
var pop_height = 0 #height info for moving
var growing : bool = false
var target_scale : Vector2 = Vector2(1, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
#appear
	if growing && pop_size < 1:
		pop_size += delta*pop_speed
		position.y = (-pop_size) * pop_height - 10
		if pop_size > 1:
			pop_size = 1
#disappear
	if !growing && pop_size > 0:
		pop_size -= delta*pop_speed
		if pop_size < 0:
			pop_size = 0
			hide() #hmm....
	scale = pop_size*target_scale
#	pass

func say(inText):
	_set_sizes(inText.length())
	text = inText
	$Text.text = text
	#$Text.scale = pop_size
	growing = true
	show()

func select(text_array):
	pass

func _set_sizes(length):
	pop_size = 0
	var x = 200
	var y = int(length/26)+1
	position.y = -y*25-20
	pop_height = (y+1)*25
	$Bubble.scale = Vector2(2.2,float(y)/5+0.2)
	$Text.rect_size = Vector2(x,y*30)

func die():
	growing = false
	#hide()
	
