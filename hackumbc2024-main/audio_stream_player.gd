extends AudioStreamPlayer

@onready var audio_stream_player: AudioStreamPlayer = $"."

# Called when the node enters the scene tree for the first time.
func play_music():
	AudioStreamPlayer.play()
