extends Node2D
var Bullet = preload("res://Bullet.tscn")
var Enemy = preload("res://Enemy.tscn")
var Player = preload("res://Player.tscn")
var Bullet2 = preload("res://Bullet2.tscn")
var Effect = preload("res://effect.tscn")
var player = Player.instance()
var bullets = []
var bullets2 = []
var Enemys = []
var Effects = []
func _ready():
	add_child(player)
	player.position.x = 512
	player.position.y = 300
	create_enemy()
	pass

func _process(delta):
	move_bullet(delta)
	move_enemy(delta)
	checkoutline()
	checkBullet()
	checkPlayercollisionEnemy(delta)
	checkEnemycollisionBullet()
	checkEnemycollisionEnemy(delta)
	checkEffect()
	
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && event.button_mask == 1: 
			var bullet = Bullet.instance()
			bullet.position = player.position
			bullet.Bullet_speed = ((get_local_mouse_position() - player.position).normalized())*600
			add_child(bullet)
			bullets.append(bullet)
			print(player.position)
		if event.is_pressed() && event.button_mask == 2:
			var bullet2 = Bullet2.instance()
			bullet2.position = player.position
			add_child(bullet2)
			bullets2.append(bullet2)
			
	if event is InputEventKey:
		if event.scancode == KEY_A  && event.pressed:
			player.set_flip(true)
		elif event.scancode == KEY_D && event.pressed:
 			player.set_flip(false)
			
func move_bullet(delta):
	for bullet in bullets:
		bullet.translate(bullet.Bullet_speed*delta)
	pass
func move_enemy(delta):
	for enemy in Enemys:
		var v_Eneamy =  ((player.position - enemy.position).normalized())*100
		enemy.translate(v_Eneamy*delta)
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
	if player.position.x < 30:
		player.position.x = 30
	if player.position.x > 994:
		player.position.x = 994
	if player.position.y < 30:
		player.position.y = 30
	if player.position.y > 570:
		player.position.y = 570
	pass
	
func checkBullet():
	for bullet in bullets:
		if bullet.position.x < 0 || bullet.position.x > 1024 || bullet.position.y < 0 || bullet.position.y > 600:
			bullets.remove(bullets.find(bullet))
			self.remove_child(bullet)
			
		
func checkPlayercollisionEnemy(delta):
	for enemy in Enemys:
		if player.position.distance_to(enemy.position)  <= 62:
			var impact = (enemy.position - player.position).normalized() * 100
			enemy.translate(delta*impact*40)
			player.hp = player.hp - enemy.damage
			print(player.hp)

func checkEnemycollisionBullet():
	for enemy in Enemys:
		for bullet in bullets:
			if enemy.position.distance_to(bullet.position) <= 40:
				var effect = Effect.instance()
				effect.position = bullet.position
				add_child(effect)
				Effects.append(effect)
				enemy.hp = enemy.hp - bullet.damage
				if enemy.hp == 0:
					Enemys.remove(Enemys.find(enemy))
					self.remove_child(enemy)
				print("Bang")
				bullets.remove(bullets.find(bullet))
				self.remove_child(bullet)

func checkEnemycollisionEnemy(delta):
	for enemy1 in Enemys:
		for enemy2 in Enemys:
			if enemy1.position.distance_to(enemy2.position) <= 60:
				var monimpact = (enemy1.position - enemy2.position).normalized()*100
				enemy1.translate(delta*monimpact)
	pass

func checkEffect():
	for effect in Effects:
		if effect.frame == 30:
			Effects.remove(Effects.find(effect))
			self.remove_child(effect)