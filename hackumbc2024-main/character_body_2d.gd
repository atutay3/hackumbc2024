extends CharacterBody2D

var direction
var facingLeft = false

var spawnPosition
var inputDict
var playerId

var speed = 70
var onGround = true

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
	var impulse = direction*15
	impulse.y = 0
	velocity += impulse
	
	velocity += Vector2(0, 9.8)
	velocity.x = velocity.x*0.9
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
	
	onGround = is_on_floor()
		
	
@onready var projectile = load("res://bullet.tscn")
@onready var main = get_parent()

func shoot(rotation, position):
	var rng = RandomNumberGenerator.new()
	
	
	for n in range(1,6):
		var bullet = projectile.instantiate()
		
		var randomSpread = deg_to_rad(rng.randf_range(-10.0, 10.0))
		
		bullet.dir = rotation + randomSpread
		bullet.spawnPosition = position
		bullet.spawnRotation = rotation + randomSpread
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
		particles = particles.duplicate()
		if particles:
			particles.emitting = true
			
			#remove_child(particles)
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
	#if event.is_action(inputDict.Dash) and event.is_action_pressed(inputDict.Dash, true, true) and not dashCD:
		#if(direction):
			#velocity += direction*800
		#else:
			#if(facingLeft):
				#velocity += Vector2(-800, 0)
			#else:
				#velocity += Vector2(800, 0)
		#dashCD = true
		#$Trail.set_meta("enableTrail", true)
		#await get_tree().create_timer(0.4).timeout
		#dashCD = false
		#$Trail.set_meta("enableTrail", false)
	
	#player jumping
	if event.is_action(inputDict.Up) and event.is_action_pressed(inputDict.Up, true, true) and onGround == true:
		velocity += Vector2(0, -200)
		onGround = false
		
	
	##player firing a gun
	if event.is_action(inputDict.Gun) and event.is_action_pressed(inputDict.Gun, true, true) and not gunCD:
		
		gunCD = true
		var rotation = PI/2
		var offsetPosition = $BarrelPoint.position
		if(facingLeft):
			rotation = 3*PI/2
			offsetPosition = Vector2(-offsetPosition.x, offsetPosition.y)
			
		shoot(rotation, offsetPosition+position)
		
		await get_tree().create_timer(1.4).timeout
		gunCD = false
			
	
signal kill
func _exit_tree() -> void:
	kill.emit(playerId)
