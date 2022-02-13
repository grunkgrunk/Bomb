extends Node


var movespeed = 300
var player_colors = [Color.blue, Color.green]

var colors = [Color("FF8E00"),Color("003F7D")]

var autoaim = false
var dash = false
var slomo = false

var playerhealth = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	recolor()
	
func recolor():
	var obs = [get_tree().get_nodes_in_group("Color1"),get_tree().get_nodes_in_group("Color2")]
	for i in range(2):
		for c in obs[i]:
			c.modulate = colors[i]
	


func swap_colors():
	colors.invert()
	recolor()


func nodes_in_group(name):
	get_tree().get_nodes_in_group(name)

func has_group_name(group, lst):
	for o in lst:
		if o.is_in_group(group):
			return true
	return false

func restart():
	get_tree().reload_current_scene()

func get_cam():
	return get_tree().get_nodes_in_group("Camera")[0]
