extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var textdict = {"Health":"3 More health", "AutoAim":"The ball is slightly homing", "Dash":"Players can dash",
				"SloMo":"Slow-motion is greatly increased" }

var type = "Health"
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = textdict[type]


func hit(dir, p):
	match type:
		"Health":
			G.playerhealth += 3
		"AutoAim":
			G.autoaim = true
		"Dash":
			G.dash = true
		"SlowMo":
			G.slomo = true
		
			
