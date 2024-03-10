extends Node

@onready var player1 = $Button_Player_1
@onready var player2 = $Button_Player_2
@export var button_sound: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	player1.stream = button_sound
	player2.stream = button_sound


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play():
	if player1.playing:
		player2.play()
	else:
		player1.play()
