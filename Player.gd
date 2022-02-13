extends KinematicBody2D

class_name Player

signal shoot
signal take_damage

export(int) var index = 0
var aim = Vector2(1,0)
var vel = Vector2()
var movespeed = 150
var extra_movespeed = 0

var cankick = true
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("killarea").connect("body_entered",self,"_on_area_enter")
	
func _physics_process(delta):
	# var movevec = Vector2();
	var dir = left_stick()
	
	var rs = right_stick()
	
	if rs.length() > 0.3:
		aim = rs.normalized()
	
	
	# Player.get_node("aim").position = aims[i] * 20
	
	rotation = atan2(aim.y, aim.x) - PI/2
	
	var spd = movespeed + extra_movespeed
	
	if Engine.time_scale != 1:
		spd = (movespeed + extra_movespeed)* 3
		
	
	extra_movespeed *=  10 * delta
	if Input.is_action_just_pressed("dash_" + str(index)) and G.dash:
		extra_movespeed = 1000
	
	
	if shoot_just_pressed():
		$AnimationPlayer.play("Shoot")
		var bods = $AimArea.get_overlapping_bodies()
		for b in bods:
			if b.is_in_group("Ball") or b.is_in_group("Monster"):
				b.hit(aim, self)
			
				
		# emit_signal("success_shoot", self)
		#if Player != last_carrier and len(bods) == 2:
		#	Engine.time_scale = 1
		#	framefreeze(0.2*(1+ball_speed/2))
		#	ball_speed += 1
		#	bomb_vel = aims[i]
		#	last_carrier = Player
	vel *= 0.7
	#if movevec != Vector2(0,0):
	#	vel = vel.linear_interpolate(movevec, 0.3)
	vel += dir * spd
	move_and_slide(vel);
	
	var col = get_last_slide_collision()
	if col != null:
		var c = col.collider
		if c.is_in_group("Monster"):
			var d = (-c.position + position).normalized()
			vel += d * 1000
			#vels[i] = vels[i].linear_interpolate(dir * 1000, 0.9)

func _on_area_enter(bod):
	if bod.is_in_group("Monster"):
		emit_signal("take_damage")
		bod.hit((bod.position - position).normalized(),self)
		
func left_stick():
	var idx = str(index)
	return Input.get_vector("move_left_"+idx, "move_right_"+idx, "move_up_"+idx, "move_down_"+idx)


func right_stick():
	var idx = str(index)
	return Input.get_vector("aim_left_"+idx, "aim_right_"+idx, "aim_up_"+idx, "aim_down_"+idx)

func shoot_just_pressed():
	var i = Input.is_action_just_pressed("shoot_" + str(index))
	if !cankick:
		return false
	if i:
		cankick = false
		pause()
		return true
	return i
	
func pause():
	yield(get_tree().create_timer(0.5),"timeout")
	cankick = true
	print("cankick")

