extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$howtoplay.visible = false
	$newgame.connect("pressed",self,"newgame");
	$how.connect("pressed",self,"Howtoplay");
	$howtoplay/back.connect("pressed",self,"back");
 	
# Replace with function body.
 
func newgame():
 get_tree().change_scene("Main.tscn")
 
func Howtoplay():
	$TextureRect.visible = false 
	$newgame.visible = false
	$how.visible = false
	$howtoplay.visible = true
 
func back():
	$howtoplay.visible = false
	$newgame.visible = true
	$how.visible = true
	$TextureRect.visible = true 
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
# pass