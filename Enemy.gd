extends KinematicBody2D

class_name Enemy

var vel = Vector2()
var health = 4
var movespeed = G.movespeed
# var ball = null
var sgn = 1
var size = 1

# Types: Tank, Killer, Catcher,

export(String, "Killer", "Tank", "Small", "Chaser") var type = "Killer"

var agressive = true

var target = ""
# export(String) var target = "Player"

onready var ball = get_tree().get_nodes_in_group("Ball")[0]


# implement vision and boid behaviour
# implement different sizes and speeds
# implement proper side stepping and change of color

func try_destroy(ball: Ball):
	if ball.success_bounces >= health:
		ball.success_bounces -= health
		queue_free()
	else:
		ball.lose_life()
		hit((position - ball.position).normalized() * 2 ,self)
		
	

# Called when the node enters the scene tree for the first time.
func _ready():
	match type:
		"Tank":
			health = 20
			movespeed = G.movespeed * 0.5
			size = 4
			target = "Middle"
		"Chaser":
			health = 4
			movespeed = G.movespeed * 1.5
			size = 1
			target = "Ball"
		"Killer":
			health = 4
			movespeed =  G.movespeed * 1.1
			target = "Player"
			size = 1
		"Small":
			health = 2
			size = 0.5
			movespeed = G.movespeed * 1.6
			target = "Player"
		
	scale = Vector2(1,1) * size
	movespeed = movespeed * 0.5
			 
	# world = get_node(world)
	#ball = get_tree().get_nodes_in_group("Ball")[0]
	#pass # Replace with function body.
	#make enemies collide into one another.

func closest_target():
	# Can we even see the target? Ray cast to find out.

	var objs = get_tree().get_nodes_in_group(target)
	var min_dst = INF
	var closest = null
	for p in objs:
		var dst = position.distance_to(p.position)
		if dst < min_dst:
			closest = p
			min_dst = dst
	return closest


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !ball.dir.length() >= 0.1:
		return
	agressive = ball.success_bounces <= health  
	if agressive:
		pass
		#$Sprite.modulate = Color(1,0,0)
	else:
		pass
		#$Sprite.modulate = Color(0,0,1)		
	
	var sep = Vector2()
	var other_enemies = get_tree().get_nodes_in_group("Enemy")
	var n_others = 0
	for e in other_enemies:
		if e == self:
			continue
		var d: Vector2 = position - e.position
		if d.length_squared() < 10000:
			sep += d + e.vel / 10
			n_others += 1
	
	if n_others != 0:
		sep = sep / n_others
	
	
	var closest = closest_target()
	if closest == null:
		return  
	
	var to = (closest.position - position).normalized()
	
	var res = (to + sep*60).normalized() * movespeed 
	
	#if !agressive:
	#	res = Vector2(res.y,-res.x)*0.2
		
	vel = vel.linear_interpolate(res,0.05*delta*100)
	var col = move_and_slide(vel)



func push(dir):
	vel = vel.linear_interpolate(dir, 0.9)

func hit(dir, p):
	vel = dir * 1000*2

func _on_ball_pass_update(ball : Ball):
	agressive = ball.success_bounces <= health  
	
