extends Sprite



func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	var player_speed = Vector2()
	if Input.is_key_pressed(KEY_D):
		player_speed.x = 250
	elif Input.is_key_pressed(KEY_A):
		player_speed.x = -250
	if Input.is_key_pressed(KEY_W):
		player_speed.y = -250
	elif Input.is_key_pressed(KEY_S):
		player_speed.y = 250
	
	self.translate(player_speed*delta)
	pass
