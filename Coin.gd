extends Area2D

export var value = 1

func _process (delta):
	# rotate 90 degrees a second
	rotation_degrees += 90 * delta	

# called when something collides with us
func _on_Coin_body_entered (body):
	# was it the player?
	if body.name == "Player":
		body.collect_coin(value)
		queue_free()

