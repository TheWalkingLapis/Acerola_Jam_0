extends Node

signal stablizer_found_done
signal pod_entered_done

@export var intros: Array[AudioStream]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_button_press():
	$"Effects/Buttons".play()

# reuse for pod itself
func start_sleeping_room_door_moving():
	$"Effects/Sleeping_Room_Door_Moving_Player".play()
	
func stop_sleeping_room_door_moving():
	$"Effects/Sleeping_Room_Door_Moving_Player".stop()
	
func start_pod_room_door_moving():
	$"Effects/Pod_Room_Door_Moving_Player".play()
	
func stop_pod_room_door_moving():
	$"Effects/Pod_Room_Door_Moving_Player".stop()
	
func start_pod_door_moving():
	$"Effects/Pod_Door_Moving_Player".play()
	
func stop_pod_door_moving():
	$"Effects/Pod_Door_Moving_Player".stop()

func start_ingame_music():
	$"Music/Ingame_Music_Player".play()

func stop_ingame_music():
	$"Music/Ingame_Music_Player".stop()

func play_morse():
	if !$"Effects/Morse_Player".playing:
		$"Effects/Morse_Player".play()
	else:
		$"Effects/Morse_Player".stop()

func play_stabilizer_missing():
	if !$"Effects/Stabilizer_Missing_Player".playing:
		$"Effects/Stabilizer_Missing_Player".play()

func play_stablizer_found():
	$"Effects/Stabilizer_Found_Player".play()
	
func play_pod_entered():
	$"Effects/Pod_Entered_Player".play()
	
func play_intro(idx):
	$Effects/Intro_Player.stream = intros[idx]
	$Effects/Intro_Player.play()

func _on_stabilizer_found_player_finished():
	stablizer_found_done.emit()

func _on_pod_entered_player_finished():
	pod_entered_done.emit()

func stop_all():
	$Effects/Buttons/Button_Player_1.stop()
	$Effects/Buttons/Button_Player_2.stop()
	$Effects/Sleeping_Room_Door_Moving_Player.stop()
	$"Effects/Pod_Room_Door_Moving_Player".stop()
	$"Effects/Pod_Door_Moving_Player".stop()
	$"Effects/Morse_Player".stop()
	$"Effects/Stabilizer_Found_Player".stop()
	$"Effects/Stabilizer_Missing_Player".stop()
	$"Effects/Pod_Entered_Player".stop()
	$"Effects/Intro_Player".stop()
	$"Music/Ingame_Music_Player".stop()

func set_music_volume(val):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), val)

func set_sound_volume(val):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), val)

func set_voice_volume(val):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voice"), val)

func set_master_volume(val):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), val)
