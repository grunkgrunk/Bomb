extends KinematicBody2D


var vel = Vector2()
var health = 3
var movespeed = 300
# var ball = null
var type = "Ball"

export(NodePath) var world = null

func get_target():
	if type == "Ball":
		return world.Bomb
	if type == "Player":
		return closest_player()


# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_node(world)
	#ball = get_tree().get_nodes_in_group("Ball")[0]
	#pass # Replace with function body.

func closest_player():
	var players = get_tree().get_nodes_in_group("Player")
	var min_dst = INF
	var closest = null
	for p in players:
		var dst = position.distance_to(p.position)
		if dst < min_dst:
			closest = p
			min_dst = dst
	return closest


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var to = (get_target().position - position).normalized() * movespeed
	vel = vel.linear_interpolate(to,0.05)
	var col = move_and_collide(vel * delta)

func push(dir):
	vel = vel.linear_interpolate(dir, 0.9)
