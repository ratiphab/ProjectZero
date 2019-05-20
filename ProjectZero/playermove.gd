extends KinematicBody2D

var hp 
var is_dead 
# Called when the node enters the scene tree for the first time.
func _ready():
	hp = 100
	is_dead = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hp <= 0 :
		is_dead = true
	else :
		var player_speed = Vector2()
		if Input.is_key_pressed(KEY_D):
			move_and_slide(Vector2(200,0))
		elif Input.is_key_pressed(KEY_A):
			move_and_slide(Vector2(-200,0))
		if Input.is_key_pressed(KEY_W):
			move_and_slide(Vector2(0,-200))
		elif Input.is_key_pressed(KEY_S):
			move_and_slide(Vector2(0,200))
func set_flip(direct):
	self.get_child(1).flip_h = direct

