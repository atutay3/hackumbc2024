extends CharacterBody2D

var direction
var facingLeft = false

var spawnPosition
var inputDict
var playerId

var speed = 70

func _ready():
	if not inputDict:
		queue_free()
	else:
		if playerId == 1:
			$Player2Image.queue_free()
		else:
			$Player1Image.queue_free()
		global_position = spawnPosition

func _physics_process(delta):
	if not playerId: return
	
	direction = Input.get_vector(inputDict.Left, inputDict.Right, inputDict.Up, inputDict.Down)
	velocity += direction*70
	velocity *= 0.9
	move_and_slide()
	
	if(velocity.x > 0):
		facingLeft = false
		#$CursorImage.flip_h = true
		scale = Vector2(1, 1)
		rotation = 0
		$WalkingParticleEmitter.position = Vector2(0, -20)
		$WalkingParticleEmitter.direction = Vector2(0, 1)
		
	elif(velocity.x < 0):
		facingLeft = true
		#$CursorImage.flip_h = false
		scale = Vector2(1, -1)
		rotation = PI
		$WalkingParticleEmitter.position = Vector2(0, 20)
		$WalkingParticleEmitter.direction = Vector2(0, -1)
	#rotation = atan2(velocity.y, velocity.x) + PI/2
	
	if velocity.length() > 200 :
		#print(velocity.length())
		$WalkingParticleEmitter.emitting = true
		#$WalkingParticleEmitter.amount = clamp(velocity.length()/100, 0, 7)
	else:
		$WalkingParticleEmitter.emitting = false
	
@onready var projectile = load("res://bullet.tscn")
@onready var main = get_parent()

func shoot(rotation, position):
	var bullet = projectile.instantiate()
	bullet.dir = rotation
	bullet.spawnPosition = position
	bullet.spawnRotation = rotation
	
	main.add_child.call_deferred(bullet)

var dashCD = false
var gunCD = false

var hp = 100
var lastHit = 0
func damage(amount):
	hp -= amount
	
	if hp<0:
		#explode
		call_deferred("queue_free")
	
		var particles = $DeathParticleEmitter
		if particles:
			particles.emitting = true
			
			remove_child(particles)
			particles.position = position
			get_parent().add_child(particles)
			await get_tree().create_timer(particles.lifetime).timeout
			particles.queue_free()
			
		#slowdown effect
	else:
		speed = 30
		lastHit = Time.get_ticks_msec()
		await get_tree().create_timer(1.2).timeout
		if Time.get_ticks_msec() - lastHit < 1200:
			speed = 70

func _input(event):
	if not playerId: return
	
	##player dashing
	if event.is_action(inputDict.Dash) and event.is_action_pressed(inputDict.Dash, true, true) and not dashCD:
		if(direction):
			velocity += direction*800
		else:
			if(facingLeft):
				velocity += Vector2(-800, 0)
			else:
				velocity += Vector2(800, 0)
		dashCD = true
		$Trail.set_meta("enableTrail", true)
		await get_tree().create_timer(0.4).timeout
		dashCD = false
		$Trail.set_meta("enableTrail", false)
	
	##player firing a gun
	if event.is_action(inputDict.Gun) and event.is_action_pressed(inputDict.Gun, true, true) and not gunCD:
		var rotation = PI/2
		var offsetPosition = $BarrelPoint.position
		if(facingLeft):
			rotation = 3*PI/2
			offsetPosition = Vector2(-offsetPosition.x, offsetPosition.y)
			
		shoot(rotation, offsetPosition+position)
			
	
signal kill
func _exit_tree() -> void:
	print("YES")
	kill.emit(playerId)
