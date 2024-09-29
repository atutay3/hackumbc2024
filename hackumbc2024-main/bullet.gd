extends CharacterBody2D

var dir
var spawnPosition
var spawnRotation

var rng = RandomNumberGenerator.new()
var speed = rng.randf_range(1000.0, 1200.0)
var bulletDamage = 9

func _ready():
	$Trail.set_meta("enableTrail", true)
	global_position = spawnPosition
	global_rotation = spawnRotation
	await get_tree().create_timer(3).timeout
	queue_free()

func _physics_process(delta):
	speed -= 15
	#speed = min(speed, 30)
	velocity = Vector2(0, -speed).rotated(dir)
	move_and_slide()

var hit = false
func _on_area_2d_body_entered(body: Node2D) -> void:
	if hit == true: return
	if body == self: return
	if body.is_class("CharacterBody2D"):
		if body.get_meta("Player") == true: return
		if body.get_meta("Bullet") == true: return
	
	hit = true
	
	if body.is_class("CharacterBody2D"):
		var impulse = 450
		if body.velocity.length() < 40: impulse = 250
		body.velocity += (body.position-position).normalized()*impulse
		body.damage(bulletDamage)
	
	call_deferred("queue_free")
	
	var particles = $BulletImpactParticles
	if not particles: return
	
	particles.emitting = true
	
	remove_child(particles)
	particles.position = position
	get_parent().add_child(particles)
	
	await get_tree().create_timer(particles.lifetime).timeout
	
