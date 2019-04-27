extends Node2D
var Bullet = preload("res://Bullet.tscn")
var Enemy = preload("res://Enemy.tscn")
var bullets = []
var Enemys =[]
func _ready():
	create_enemy()
	pass

func _process(delta):
	move_bullet(delta)
	move_enemy(delta)
	checkoutline()
	checkBullet()
	checkPlayercollisionEnemy()
	checkEnemycollisionBullet()
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && event.button_mask == 1: 
			var bullet = Bullet.instance()
			bullet.position = $Player.position
			bullet.Bullet_speed = ((get_local_mouse_position() - $Player.position).normalized())*600
			add_child(bullet)
			bullets.append(bullet)
			
func move_bullet(delta):
	for bullet in bullets:
		bullet.translate(bullet.Bullet_speed*delta)
	pass
func move_enemy(delta):
	for enemy in Enemys:
		var v_Enemy =  (($Player.position - enemy.position).normalized())*100
		enemy.translate(v_Enemy*delta)
	pass
func create_enemy():
	for a in range(1,3):
		var enemy = Enemy.instance()
		if a % 2 == 0:
			enemy.position = Vector2(200,0) 
		else:
			enemy.position = Vector2(0,200) 
		add_child(enemy)
		Enemys.append(enemy)
	pass

func checkoutline():
	if $Player.position.x < 30:
		$Player.position.x = 30
	if $Player.position.x > 994:
		$Player.position.x = 994
	if $Player.position.y < 30:
		$Player.position.y = 30
	if $Player.position.y > 570:
		$Player.position.y = 570
	pass
	
func checkBullet():
	for bullet in bullets:
		if bullet.position.x < 0 || bullet.position.x > 1024 || bullet.position.y < 0 || bullet.position.y > 600:
			bullets.remove(bullets.find(bullet))
			self.remove_child(bullet)
		
func checkPlayercollisionEnemy():
	for enemy in Enemys:
		if $Player.position.distance_to(enemy.position)  <= 62:
			print("check")

func checkEnemycollisionBullet():
	for enemy in Enemys:
		for bullet in bullets:
			if enemy.position.distance_to(bullet.position) <= 40:
				enemy.hp = enemy.hp - bullet.damage
				if enemy.hp == 0:
					Enemys.remove(Enemys.find(enemy))
					self.remove_child(enemy)
				print("Bang")
				bullets.remove(bullets.find(bullet))
				self.remove_child(bullet)
			