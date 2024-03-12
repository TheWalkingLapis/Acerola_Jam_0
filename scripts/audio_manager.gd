extends Node


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
