extends Position2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var objs = get_tree().get_nodes_in_group("Player")
	var avg = (objs[0].position + objs[1].position)/2
	position = avg

