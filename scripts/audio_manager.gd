extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_button_press():
	$"Effects/Buttons".play()

func start_ingame_music():
	$"Music/Ingame_Music_Player".play() # TODO is currently autoplay, remove that

func stop_ingame_music():
	$"Music/Ingame_Music_Player".stop()
