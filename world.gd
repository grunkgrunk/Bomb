extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Polygon2D.polygon
	var ps = get_tree().get_nodes_in_group("Player")
	$healthlabel.text = str(G.playerhealth)
	for p in ps:
		p.connect("take_damage",self,"lose_health")
		
	$Ball.connect("take_damage", self, "lose_health")
		
func lose_health():
	G.playerhealth -= 1
	if G.playerhealth <= 0:
		get_tree().reload_current_scene()
	$healthlabel.text = str(G.playerhealth)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	VisualServer.set_default_clear_color(G.colors[1])
	
	if len(get_tree().get_nodes_in_group("Enemy")) <= 0:
		$Shop.open_shop()
	
	
	if Input.is_action_just_pressed("restart"):
		#get_tree().reload_current_scene()
		for n in get_tree().get_nodes_in_group("Enemy"):
			n.queue_free()
		
