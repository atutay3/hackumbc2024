extends Node

var player
var main

func spawnCharacter(id, spawnPos):
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
	
	return newPlr

var player1
var player2
func _respawn(playerId):
	await get_tree().create_timer(3).timeout
	if playerId == 1:
		player1 = spawnCharacter(1, Vector2(200, 200))
		player1.kill.connect(_respawn)
	else:
		player2 = spawnCharacter(2, Vector2(800, 200))
		player2.kill.connect(_respawn)

func _ready():
	player = load("res://character_body_2d.tscn")
	main = get_parent()
	
	player1 = spawnCharacter(1, Vector2(200, 200))
	player2 = spawnCharacter(2, Vector2(800, 200))
	
	player1.kill.connect(_respawn)
	player2.kill.connect(_respawn)
	
