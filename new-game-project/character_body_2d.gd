extends CharacterBody2D

var direction
var facingLeft = false

func _physics_process(delta):
	direction = Input.get_vector("P1Left", "P1Right", "P1Up", "P1Down")
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

func _input(event):
	
	##player dashing
	if event.is_action("P1Dash") and event.is_action_pressed("P1Dash", true, true) and not dashCD:
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
	if event.is_action("P1Gun") and event.is_action_pressed("P1Gun", true, true) and not gunCD:
		var rotation = PI/2
		if(facingLeft):
			rotation = 3*PI/2
			
		shoot(rotation, $BarrelPoint.position+position)
			
	
