extends KinematicBody2D


var vel = Vector2()
var health = 3
var movespeed = 100
# var ball = null

export(NodePath) var world = null

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
	var to = (closest_player().position - position).normalized() * movespeed
	vel = vel.linear_interpolate(to,0.05)
	var col = move_and_collide(vel * delta)
	if col != null:
		var o = col.collider
		if o.is_in_group("Player"):
			pass

func push(dir):
	vel = vel.linear_interpolate(dir, 0.9)
