extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	speed_scale = .5
	play("walk p1")

func on_animation_finish(anim_name):
	play("walk p1")
