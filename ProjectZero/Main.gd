extends Node2D
var Bullet = preload("res://Bullet.tscn")
var Enemy = preload("res://Enemy.tscn")
var Player = preload("res://Player.tscn")
var Bullet2 = preload("res://Bullet2.tscn")
var Effect = preload("res://effect.tscn")
var Effect2 = preload("res://effect2.tscn")
var ItemHeart = preload("res://Itemheart.tscn")
var ItemPower = preload("res://Itempower.tscn")
var ItemSpeed = preload("res://Itemspeed.tscn")
var player = Player.instance()
var bullets = []
var bullets2 = []
var Enemys = []
var Effects = []
var Effects2 = []
var areas = []
var bullet1_cd = true
var bullet2_cd = true
var timeout = false
var itemhearts = []
var itempowers = []
var itemspeeds = []
var Ddamage = 1 
func _ready():
	add_child(player)
	player.position.x = 512
	player.position.y = 300
	create_enemy()

func _process(delta):
	if !player.is_dead:
		move_bullet(delta)
		move_enemy(delta)
		checkoutline()
		checkBullet()
		checkPlayercollisionEnemy(delta)
		checkEnemycollisionBullet()
		checkEnemycollisionEnemy(delta)
		checkEffect()
		checkEffect2()
		checkEnemycollisionBullet2()
		checkEnemycollisionEffect2()
		checkHPbar()
		pickHeart()
		pickSpeed()
		pickPower()
		$Arrow.visible = false
	if timeout && Enemys.size() == 0 :
		$Arrow.visible = true
		print("------------")
		print("Success")
		print("------------")
		
#		$TileMap.visible = false
#		$TileMap2.visible = false
#		$Control.visible = false 
#		player.visible = false
	pass
	
func checkBulletcollsionWall():
	

	for area in areas:
		print(area)
	
	pass
	
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && event.button_mask == 1 && bullet1_cd && !player.is_dead:
			bullet1_cd = false
			$Timer_bullet_1.start(0)
			var bullet = Bullet.instance()
			bullet.position = player.position
			bullet.Bullet_speed = ((get_local_mouse_position() - player.position).normalized())*600
			add_child(bullet)
			bullets.append(bullet)
		if event.is_pressed() && event.button_mask == 2 && bullet2_cd && !player.is_dead:
			bullet2_cd = false
			$Timer_bullet_2.start(0)
			var bullet2 = Bullet2.instance()
			bullet2.position = player.position
			bullet2.Bullet_speed = ((get_local_mouse_position() - player.position).normalized())*600
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
	for bullet in bullets2:
		bullet.translate(bullet.Bullet_speed*delta)
	pass
func move_enemy(delta):
	for enemy in Enemys:
		var v_Eneamy =  ((player.position - enemy.position).normalized())*100
		enemy.move_and_slide(v_Eneamy)
	pass
func create_enemy():
	if !timeout:
		for a in range(1,5):
			var enemy = Enemy.instance()
			if a % 4 == 0:
				enemy.position = Vector2(200,500) 
			elif a % 4 == 1:
				enemy.position = Vector2(1000,200)
			elif a % 4 == 3:
				enemy.position = Vector2(600,500)
			else:
				enemy.position = Vector2(600,200) 
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
		if bullet.position.x < 0 || bullet.position.x > 1024 || bullet.position.y < 0 || bullet.position.y > 600||bullet.isdis:
			var effect = Effect.instance()
			effect.position = bullet.position
			add_child(effect)
			Effects.append(effect)
			bullets.remove(bullets.find(bullet))
			self.remove_child(bullet)
	for bullet2 in bullets2:
		if bullet2.position.x < 0 || bullet2.position.x > 1024 || bullet2.position.y < 0 || bullet2.position.y > 600||bullet2.isdis:
			var effect2 = Effect2.instance()
			effect2.position = bullet2.position
			add_child(effect2)
			Effects2.append(effect2)
			bullets2.remove(bullets2.find(bullet2))
			self.remove_child(bullet2)	
		
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
				enemy.hp = enemy.hp - (bullet.damage * Ddamage)
				print(enemy.hp)
				if enemy.hp <= 0:
					randomItem(enemy)
					Enemys.remove(Enemys.find(enemy))
					self.remove_child(enemy)
				bullets.remove(bullets.find(bullet))
				self.remove_child(bullet)

func checkEnemycollisionBullet2():
	for enemy in Enemys:
		for bullet in bullets2:
			if enemy.position.distance_to(bullet.position) <= 40:
				var effect2 = Effect2.instance()
				effect2.position = bullet.position
				add_child(effect2)
				Effects2.append(effect2)
				bullets2.remove(bullets2.find(bullet))
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
	

func _on_Timer_Monster_timeout():
	create_enemy()
	pass # Replace with function body.


func _on_Timer_bullet_1_timeout():
	if !bullet1_cd :
		bullet1_cd = true
	pass # Replace with function body.
	
func checkEffect2():
	for effect2 in Effects2:
		if effect2.getframe() == 30:
			Effects2.remove(Effects2.find(effect2))
			self.remove_child(effect2)

func checkEnemycollisionEffect2():
	for enemy in Enemys:
		for effect in Effects2:
			if effect.position.distance_to(enemy.position) <= 40:
				enemy.hp = enemy.hp - (effect.damage * Ddamage)
				if enemy.hp < 0:
					Enemys.remove(Enemys.find(enemy))
					self.remove_child(enemy)

func checkHPbar():
	$Control/HBoxContainer/TextureProgress.value = player.hp

func _on_Timer_bullet_2_timeout():
	if !bullet2_cd :
		bullet2_cd = true
	pass # Replace with function body.


func _on_Timer_per_state_timeout():
	
	if !timeout:
		timeout = true
	pass # Replace with function body.

func randomItem(enemy):
	var ran = randi()%10
	if ran == 8 || ran == 4:
		var heart = ItemHeart.instance()
		heart.position = enemy.position
		add_child(heart)
		itemhearts.append(heart)
	elif ran == 2:
		var power = ItemPower.instance()
		power.position = enemy.position
		add_child(power)
		itempowers.append(power)
	elif ran == 7:
		var speed = ItemSpeed.instance()
		speed.position = enemy.position 
		add_child(speed)
		itemspeeds.append(speed)
		

func pickHeart():
	for item in itemhearts:
		if !player.hp == 100:
			if player.position.distance_to(item.position) <= 40:
				player.hp = player.hp + item.hp
				itemhearts.remove(itemhearts.find(item))
				self.remove_child(item)

func pickSpeed():
	for item in itemspeeds:
		if player.position.distance_to(item.position) <= 40:
			player.speed = 300
			$Timer_speed.start()
			itemspeeds.remove(itemspeeds.find(item))
			self.remove_child(item)

func pickPower():
	for item in itempowers:
		if player.position.distance_to(item.position) <= 40:
			Ddamage = 2
			$Timer_power.start()
			itemspeeds.remove(itemspeeds.find(item))
			self.remove_child(item)
			
func _on_Timer_speed_timeout():
	player.speed = 200
	pass # Replace with function body.
	
func _on_Timer_power_timeout():
	Ddamage = 1
	pass # Replace with function body.
