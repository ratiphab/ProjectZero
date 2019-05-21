extends Node2D
var Bullet = preload("res://Bullet.tscn")
var Enemy = preload("res://Enemy.tscn")
var Enemy2 = preload("res://Enemy2.tscn")
var Player = preload("res://Player.tscn")
var Bullet2 = preload("res://Bullet2.tscn")
var Effect = preload("res://effect.tscn")
var Effect2 = preload("res://effect2.tscn")
var ItemHeart = preload("res://Itemheart.tscn")
var ItemPower = preload("res://Itempower.tscn")
var ItemSpeed = preload("res://Itemspeed.tscn")
var Tilemap2 = preload("res://TileMap2.tscn")
var Tilemap3 = preload("res://TileMap3.tscn")
var tilemap2 = Tilemap2.instance()
var tilemap3 = Tilemap3.instance()
var player = Player.instance()
var bullets = []
var bullets2 = []
var Enemys = []
var Effects = []
var Effects2 = []
var bullet1_cd = true
var bullet2_cd = true
var timeout = false
var prepare = true
var itemhearts = []
var itempowers = []
var itemspeeds = []
var Ddamage = 1 
var numstate = 1
var iswin = false

func _ready():
	add_child(player)
	player.position.x = 512
	player.position.y = 300

func _process(delta):
	if !player.is_dead :
		move_bullet(delta)
		move_enemy()
		checkoutline()
		checkBullet(numstate)
		checkPlayercollisionEnemy(delta)
		checkEnemycollisionBullet()
		checkEnemycollisionEnemy(delta)
		checkEffect()
		checkEffect2()
		checkEnemycollisionBullet2()
		checkEnemycollisionEffect2()
		checkHPbar()
		checkTimebar()
		pickHeart()
		pickSpeed()
		pickPower()
		checkCd2bar()
		checknextstate()
		Gonextstate()
	
	if player.is_dead:
		get_tree().change_scene("Gameover.tscn")
#			$Timer_per_state.stop()
#			player.hp = 100
#			timeout = false
#			$Arrow.visible = false
#			visible = false
#			$Timer_prepare.start(0)
#			deleteAllitem()
#			player.position = Vector2(512,100)
#			numstate = 1
#			$TileMap.visible = true 
#			$TileMap2.visible = true 
#			timeout = false
#			prepare = true
#			$Timer_prepare_before_start.start(0)
#			$Timer_Monster.stop()
#			for enemy in Enemys:
#				self.remove_child(enemy)
#			Enemys.clear()
#			player.is_dead = false
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
func move_enemy():
	for enemy in Enemys:
		var v_Eneamy =  ((player.position - enemy.position).normalized())*100
		enemy.move_and_slide(v_Eneamy)
	pass
func create_enemy():
	if !timeout:
		for a in range(1,5):
			var enemy = Enemy.instance()
			if a % 4 == 0:
				if numstate == 1:
					enemy.position = Vector2(200,500) 
				if numstate == 2:
					enemy.position = Vector2(200,500) 
				if numstate == 3:
					enemy.position = Vector2(160,170) 
				add_child(enemy)
				Enemys.append(enemy) 
			elif a % 4 == 1:
				if numstate == 1:
					enemy.position = Vector2(1000,200)
				if numstate == 2:
					enemy.position = Vector2(1000,200) 
				if numstate == 3:
					enemy.position = Vector2(930,500) 
				add_child(enemy)
				Enemys.append(enemy)
			elif a % 4 == 3:
				if numstate == 1:
					enemy.position = Vector2(600,500)
				if numstate == 2:
					enemy.position = Vector2(600,500)
				if numstate == 3:
					enemy.position = Vector2(500,500) 
				add_child(enemy)
				Enemys.append(enemy)
			else:
				if numstate == 1:
					enemy.position = Vector2(600,200) 
				if numstate == 2:
					enemy.position = Vector2(600,200) 
				if numstate == 3:
					enemy.position = Vector2(760,160) 
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
	
func checkBullet(numstate):
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
			enemy.move_and_slide(impact*40)
			player.hp = player.hp - enemy.damage

func checkEnemycollisionBullet():
	for enemy in Enemys:
		for bullet in bullets:
			if enemy.position.distance_to(bullet.position) <= 40:
				var effect = Effect.instance()
				effect.position = bullet.position
				add_child(effect)
				Effects.append(effect)
				enemy.hp = enemy.hp - (bullet.damage * Ddamage)
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
	if !prepare:
		create_enemy()
	pass # Replace with function body.
func _on_Timer_bullet_1_timeout():
	$Timer_bullet_1.stop()
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
	$Timer_bullet_2.stop()
	if !bullet2_cd :
		bullet2_cd = true
	pass # Replace with function body.
func _on_Timer_per_state_timeout():
	$Timer_per_state.stop()
	prepare = true
	if !timeout:
		timeout = true
	pass # Replace with function body.
func randomItem(enemy):
	var ran = randi()%8
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
func checkTimebar():
	$Control/HBoxContainer2Timer/TextureProgress.value = (int((100 * ($Timer_per_state.time_left))/$Timer_per_state.wait_time))
func checkCd2bar():
	var time = int($Timer_bullet_2.time_left)
	if time == 5:
		$Control/HBoxContainerCD2/TextureProgress.value = 0
	elif time == 4:
		$Control/HBoxContainerCD2/TextureProgress.value = 20
	elif time == 3:
		$Control/HBoxContainerCD2/TextureProgress.value = 40
	elif time == 2:
		$Control/HBoxContainerCD2/TextureProgress.value = 60
	elif time == 1:
		$Control/HBoxContainerCD2/TextureProgress.value = 80
	elif time == 0:
		$Control/HBoxContainerCD2/TextureProgress.value = 100
	pass
func checknextstate():
	if player.position.distance_to($Arrow.position) <=40 && $Arrow.visible:
		if numstate == 3 :
			get_tree().change_scene("win.tscn")
		else:
			player.position = Vector2(512,100)
			$Timer_prepare.start(0)
			visible = false
			numstate = numstate +1
			deleteAllitem()
func _on_Timer_prepare_timeout():
	visible = true
	prepare = true
	$Arrow.visible = false
	$Timer_prepare_before_start.start(0)
	player.position = Vector2(512,100)
	$Timer_prepare.stop()
	if numstate == 2:
		$Timer_Monster.wait_time = 4
		self.remove_child($TileMap2)
		self.add_child(tilemap2)
		print(self.get_path_to(tilemap2))
		print(tilemap2.name)
	if numstate == 3:
		$Timer_Monster.wait_time = 3
		self.remove_child(tilemap2)
		self.add_child(tilemap3)
		print(self.get_path_to(tilemap3))
		print(tilemap3.name)
	pass # Replace with function body.
func Gonextstate():
	if timeout && Enemys.size() == 0 :
		timeout = false
		$Arrow.visible = true
func _on_Timer_prepare_before_start_timeout():
	$Timer_prepare_before_start.stop()
	$Timer_Monster.start(0)
	prepare = false
	create_enemy()
	$Timer_per_state.start(0)
	pass # Replace with function body.
func deleteAllitem():
	var maxindex = 0
	if itemhearts.size() > maxindex:
		maxindex = itemhearts.size()
	elif itemspeeds.size() > maxindex:
		maxindex = itemspeeds.size()
	elif itempowers.size() > maxindex:
		maxindex = itempowers.size()
	for a in range(0,maxindex+1):
		for item in itemhearts:
			self.remove_child(item)
			itemhearts.remove(itemhearts.find(item))
		for item in itempowers:
			self.remove_child(item)
			itempowers.remove(itempowers.find(item))
		for item in itemspeeds:
			self.remove_child(item)
			itemspeeds.remove(itemspeeds.find(item))