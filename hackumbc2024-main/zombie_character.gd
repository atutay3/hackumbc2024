extends CharacterBody2D

var direction
var facingLeft = false

var spawnPosition
var inputDict
var playerId

var speed = 70
var onGround = true

func _ready():
	global_position = spawnPosition

func _physics_process(delta):
	if not playerId: return
	
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
		
	elif(velocity.x < 0):
		facingLeft = true
		#$CursorImage.flip_h = false
		scale = Vector2(1, -1)
		rotation = PI

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

signal kill
func _exit_tree() -> void:
	kill.emit(playerId)


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
