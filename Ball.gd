extends KinematicBody2D

class_name Ball

signal take_damage
export(AudioStreamSample) var slow_ball
export(AudioStreamSample) var fast_ball

var dir = Vector2()
var success_bounces = 0
var last_hitter = null
var streak = 0
var slomo = 0.3

onready var label = get_parent().get_node("Label")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#$Area2D.connect("body_entered", self, "on_body_enter")
	#$Area2D.connect("body_exited", self, "on_body_exit")
	
func current_hitter_in_area():
	if last_hitter == null:
		return null
	for o in $Area2D.get_overlapping_bodies() :
		if o.is_in_group("Player") and o != last_hitter:
			return o
	return null

func update_slow_motion():
	# var effect = AudioServer.get_bus_effect(AudioServer.get_bus_index("Master"), 0)
	if current_hitter_in_area() != null:
		if G.slomo:
			Engine.time_scale = slomo/3
		else:
			Engine.time_scale = slomo 
			
		#effect.cutoff_hz = 600
	else:
		#effect.cutoff_hz = 2000
		Engine.time_scale = 1
	

func slow_motion():
	var last = Engine.time_scale
	update_slow_motion()
	if abs(last - Engine.time_scale) > 0.01:
		# Slowmo time just changed
		print("time changed!")

	

func bounce(normal):
	dir = dir.bounce(normal).normalized()
	streak = 0
	success_bounces = 0
	# success_bounces = max(0,success_bounces-1)
	
func _process(delta):
	label.text = str(success_bounces)
	# Seek the player
	if G.autoaim:
		var o = current_hitter_in_area()
		if o != null:
			var to = o.position - position
			if to.dot(dir) > 0:
				dir = dir.linear_interpolate(to.normalized(), 2*delta).normalized()
		
	
	var collision = move_and_collide(dir * delta * G.movespeed * (1+success_bounces/4))
	if collision != null: 
		var col = collision.collider
		if col.is_in_group("Monster"):
			col.try_destroy(self)
		else:
			bounce(collision.normal)
	
	slow_motion()
	
	
	#if PlayerToHit.position.distance_to(Bomb.position) < 200:
	#	Engine.time_scale = slomo
	#elif abs(Engine.time_scale - slomo) <= 0.1:
	#	Engine.time_scale = 1
			

func lose_life():
	streak = 0
	pass
	#emit_signal("take_damage")
	

func hit(new_dir: Vector2, hitter: Player):
	if hitter != last_hitter:
		G.swap_colors()
		if last_hitter:
			last_hitter.get_node("Sprites/Sprite2").hide()
		
		hitter.get_node("Sprites/Sprite2").show()
		
		streak += 0.5
		success_bounces += streak
		dir = new_dir
		last_hitter = hitter
		$audio.stream = slow_ball
		if success_bounces >= 10:
			$audio.stream = fast_ball
		$audio.play()
		G.get_cam().add_trauma(0.5)
		#print(get_viewport().get_camera())
		# get_viewport().get_camera().add_trauma(200)
