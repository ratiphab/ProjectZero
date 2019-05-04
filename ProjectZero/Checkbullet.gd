extends Area2D

var Bullet_speed
var isdis = false
var damage = 50 
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "TileMap2":
		isdis = true
	pass # Replace with function body.
