extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(PackedScene) var powerup
var poweruplist = ["Health", "AutoAim", "Dash", "SloMo"]

var isopen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func open_shop():
	if isopen:
		return
	isopen = true
	poweruplist.shuffle()
	for i in range(3):
		var inst= powerup.instance()
		inst.type = poweruplist[i]
		inst.position = get_node("p"+str(i+1)).position
		add_child(inst)
		
	G.recolor()

func close_shop():
	isopen = false
	for p in get_tree().get_nodes_in_group("Powerup"):
		p.queue_free()
