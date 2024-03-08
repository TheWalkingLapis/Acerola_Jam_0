extends Node3D

@onready var pod_room_scanner: Node3D = $"Scanner_pod_room"
@onready var pod_room: Node3D = $"../PodRoom"

@onready var sleeping_room_button: Node3D = $"Sleeping_Room_Button"
@onready var sleeping_room: Node3D = $"../SleepingRoom"

func _ready():
	pod_room_scanner.attach_to_door(pod_room.open_living_room_door)
	sleeping_room_button.attach_to_door(sleeping_room.open_living_room_door)
	
	# MoonBase/Interior/LivingRoom
	# MoonBase/Keycard
	pod_room_scanner.set_keycard(get_parent().get_parent().get_node("Keycard"))

func _process(delta):
	pass
