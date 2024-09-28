extends Line2D

const MAX_POINTS = 50
@onready var curve := Curve2D.new()

func _process(delta) -> void:
	var character = get_parent()
	var charFacingLeft = character.scale.y > 0 

	
	var enabled = get_meta("enableTrail")
	#if not enabled:
		#curve.add_point(lastPos)
		#return
	
	var newPos = character.position
	if enabled: curve.add_point(newPos)
	
	if curve.get_baked_points().size() > MAX_POINTS or (not enabled and curve.get_baked_points().size() >  0):
		curve.remove_point(0)
		
	if enabled:
		points = curve.get_baked_points()
	else:
		points = PackedVector2Array()

		
		
