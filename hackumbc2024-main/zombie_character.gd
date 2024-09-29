extends CharacterBody2D

var direction
var facingLeft = false

var spawnPosition
var angerArea

var speed = 30
var onGround = true

var targetPlayer

var impulse = Vector2(0,0)
func aggro(body):
	if body.is_class("CharacterBody2D") and body.get_meta("Player") == true:
		targetPlayer = body

func _ready():
	#print("ready")
	global_position = spawnPosition
	angerArea.body_entered.connect(aggro)

func _physics_process(delta):
	
	if targetPlayer and is_instance_valid(targetPlayer):
		impulse = (targetPlayer.position - position).normalized()*4
	else:
		impulse = Vector2(0,0)
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
		
	elif(velocity.x < 0):
		facingLeft = true
		#$CursorImage.flip_h = false
		scale = Vector2(1, -1)
		rotation = PI

var hp = 50
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
		speed = 10
		lastHit = Time.get_ticks_msec()
		await get_tree().create_timer(1.2).timeout
		if Time.get_ticks_msec() - lastHit < 1200:
			speed = 30

signal kill
func _exit_tree() -> void:
	kill.emit(self)

var hit = false
var hitCD = .2
var hitDamage = 23
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_class("CharacterBody2D") and body.get_meta("Player") == true and hit == false:
		hit = true
	
		var impulse = 550
		if body.velocity.length() < 40: impulse = 750
		body.velocity += (body.position-position).normalized()*impulse
		velocity -= (body.position-position).normalized()*impulse
		body.damage(hitDamage)
		damage(hitDamage/2)
		
		await get_tree().create_timer(hitCD).timeout
		hit = false
