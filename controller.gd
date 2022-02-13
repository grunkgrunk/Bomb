extends Node2D


# Declare member variables here. Examples:
var movespeed = 600;

# var b = "text"

#var onwall = false;
var hasball = false;

var bomb_vel = Vector2()

var ball_speed = 0
onready var Bomb = $Bomb

var aiming = false
var carrier = null
var last_carrier = null

# var jumps = 0;

var slomo = 0.2
var timescale  = 1


var colors = [Color.blue, Color.green]

var trigger_time_change = false

# onready var Player = $Player;
onready var Players = [$Player0, $Player1]

var aims = [Vector2(1,0),Vector2(1,0)]
var vels = [Vector2(), Vector2()]

# Called when the node enters the scene tree for the first time.
func _ready():
	#carrier = Players[0]
	for i in range(2):
		Players[i].get_node("Sprite").modulate = colors[i]

func move_for_pl(idx):
	idx = str(idx)
	return Input.get_vector("move_left_"+idx, "move_right_"+idx, "move_up_"+idx, "move_down_"+idx)


func aim_for_pl(idx):
	idx = str(idx)
	return Input.get_vector("aim_left_"+idx, "aim_right_"+idx, "aim_up_"+idx, "aim_down_"+idx)

func framefreeze(dur):
	var last = Engine.time_scale
	Engine.time_scale = 0.03
	yield(get_tree().create_timer(dur*0.05),"timeout")
	Engine.time_scale = last

func get_player_index(player):
	if Players[0] == player:
		return 0
	return 1
	

func ball_collision(delta):
	var collision = Bomb.move_and_collide(bomb_vel * delta* movespeed*(1+ball_speed/5))
	if collision != null: 
		var col = collision.collider
		if col.is_in_group("Monster"):
			if ball_speed >= 4:
				ball_speed -= 4
				col.queue_free()
			else:
				restart()
				col.push(bomb_vel * 300)
				bomb_vel = bomb_vel.bounce(collision.normal).normalized()
				ball_speed = max(0,ball_speed-1)
		else:
			bomb_vel = bomb_vel.bounce(collision.normal).normalized()
			ball_speed = max(0,ball_speed-1)

func move_player(i):
	var movevec = Vector2();
	var Player = Players[i]
	var velocity = move_for_pl(i)
	var aim = aim_for_pl(i)
	
	
	if aim != Vector2():
		aims[i] = aim.normalized()
	
	# Player.get_node("aim").position = aims[i] * 20
	
	Player.rotation = atan2(aims[i].y, aims[i].x) - PI/2
	
	
	if Engine.time_scale == 1:
		movevec = velocity * movespeed
	else:
		movevec = velocity * movespeed * 1.5
	
	
	if Input.is_action_just_pressed("shoot_" + str(i)):
		var bods = Player.get_node("aim/AimArea").get_overlapping_bodies()
		if Player != last_carrier and len(bods) == 2:
			Engine.time_scale = 1
			framefreeze(0.2*(1+ball_speed/2))
			ball_speed += 1
			bomb_vel = aims[i]
			last_carrier = Player
	
	vels[i] = vels[i].linear_interpolate(movevec, 0.3)
	Player.move_and_slide(vels[i]);
	
	var col = Player.get_last_slide_collision()
	if col != null:
		var c = col.collider
		if c.is_in_group("Monster"):
			var dir = (-c.position + Player.position).normalized()
			vels[i] = vels[i].linear_interpolate(dir * 1000, 0.9)


func restart():
	get_tree().reload_current_scene()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if carrier == null:
		var color = colors[(get_player_index(last_carrier) + 1) % 2]
		Bomb.get_node("Sprite").modulate = color
		ball_collision(delta)
		#bomb_vel.y += grav * delta * 20
		#Bomb.position += bomb_vel * delta
		
			
	$Label.text = str(ball_speed)
	#Bomb.shape
	
	#	for col in Bomb.get_overlapping_bodies():
	#		if col.is_in_group("Player") and col != last_carrier:
	#			carrier = col
	#			Engine.time_scale = slomo
	
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	#if Input.is_action_pressed("ui_right"):
	#	movevec.x += movespeed;
	#if Input.is_action_pressed("ui_left"):
	#	movevec.x -= movespeed
	
	var PlayerToHit = Players[(get_player_index(last_carrier) + 1) % 2]
	
	if PlayerToHit.position.distance_to(Bomb.position) < 200:
		Engine.time_scale = slomo
	elif abs(Engine.time_scale - slomo) <= 0.1:
		Engine.time_scale = 1
	

	#Engine.time_scale = 1
	for i in range(2):
		move_player(i)
		


