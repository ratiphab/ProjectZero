extends Area2D
var isdis = false
var Bullet_speed
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "TileMap2" || body.name == "TileMap3":
		isdis = true
	pass # Replace with function body.
