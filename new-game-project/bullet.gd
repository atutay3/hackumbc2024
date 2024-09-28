extends CharacterBody2D

var dir
var spawnPosition
var spawnRotation

var speed = 600

func _ready():
	global_position = spawnPosition
	global_rotation = spawnRotation
	await get_tree().create_timer(3).timeout
	queue_free()

func _physics_process(delta):
	velocity = Vector2(0, -speed).rotated(dir)
	move_and_slide()
