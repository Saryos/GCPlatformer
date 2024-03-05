extends Camera2D

onready var player = get_node("/root/MainScene/Player")

# tracks the player
func _process (_delta):
	position.x = player.position.x
	if player.position.y < player.bottom_death:
		position.y = player.position.y
	
