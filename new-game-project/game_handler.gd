extends Node

var player
var main

func spawnCharacter(id, spawnPos):
	print(spawnPos)
	var newPlr = player.instantiate()
	newPlr.playerId = id
	
	newPlr.spawnPosition = spawnPos
	
	var controlDict
	if id==1:
		controlDict = {
			"Left": "P1Left",
			"Right": "P1Right",
			"Up": "P1Up",
			"Down": "P1Down",
			"Dash": "P1Dash",
			"Gun": "P1Gun",
		}
	elif id==2:
		controlDict = {
			"Left": "P2Left",
			"Right": "P2Right",
			"Up": "P2Up",
			"Down": "P2Down",
			"Dash": "P2Dash",
			"Gun": "P2Gun",
		}
		
	newPlr.inputDict = controlDict
	
	main.add_child.call_deferred(newPlr)

func _ready():
	player = load("res://character_body_2d.tscn")
	main = get_parent()
	
	spawnCharacter(1, Vector2(200, 200))
	spawnCharacter(2, Vector2(800, 200))
