extends Node

var player
var main
var zombie

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

func spawnZombie(nodePos, area):
	var newPlr = zombie.instantiate()
	newPlr.spawnPosition = nodePos.position
	newPlr.angerArea = area
	main.add_child.call_deferred(newPlr)

var player1
var player2
func _respawn(playerId):
	await get_tree().create_timer(3).timeout
	if playerId == 1:
		player1 = spawnCharacter(1, Vector2(-200, 200))
		player1.kill.connect(_respawn)
	else:
		player2 = spawnCharacter(2, Vector2(-300, 200))
		player2.kill.connect(_respawn)

func _ready():
	player = load("res://character_body_2d.tscn")
	zombie = load("res://zombie_character.tscn")
	main = get_parent()
	
	player1 = spawnCharacter(1, Vector2(-250, 200))
	player2 = spawnCharacter(2, Vector2(-300, 200))
	
	player1.kill.connect(_respawn)
	player2.kill.connect(_respawn)
	
	#spawn zombies
	var zone1 = $ZombieSpawnLocations/Zone1
	var zone2 = $ZombieSpawnLocations/Zone2
	var zone3 = $ZombieSpawnLocations/Zone3
	

	
	for N in zone1.get_children():
		spawnZombie(N, $Collision/ZombieAngerRange1)
		
	for N in zone2.get_children():
		spawnZombie(N, $Collision/ZombieAngerRange2)
		
	for N in zone3.get_children():
		spawnZombie(N, $Collision/ZombieAngerRange3)
	
