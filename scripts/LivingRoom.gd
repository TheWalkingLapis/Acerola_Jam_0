extends Node3D

signal left_pc_interaction

@onready var pod_room_scanner: Node3D = $"Scanner_pod_room"
@onready var pod_room: Node3D = $"../PodRoom"

@onready var sleeping_room_button: Node3D = $"Sleeping_Room_Button"
@onready var sleeping_room: Node3D = $"../SleepingRoom"

# Control/Environement/MoonBase/Interior/LivingRoom
# Control/Audio_Manager
@onready var audio_manager = $"../../../../Audio_Manager"

func _ready():
	# Control/Environment/MoonBase/Interior/LivingRoom
	# Control/Player
	left_pc_interaction.connect(get_parent().get_parent().get_parent().get_parent().get_node("Player")._unblock_input)
	
	pod_room_scanner.attach_to_door(pod_room.open_living_room_door)
	pod_room_scanner.audio_func(audio_manager.play_button_press)
	# MoonBase/Interior/LivingRoom
	# MoonBase/Keycard
	pod_room_scanner.set_keycard(get_parent().get_parent().get_node("Keycard"))
	
	sleeping_room_button.attach_to_door(sleeping_room.open_living_room_door)
	
	

func _process(delta):
	pass

# called by player (blocks input by himself)
func enter_pc_interaction():
	$"../../PC_Interface".visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func leave_pc_interaction():
	$"../../PC_Interface".visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	left_pc_interaction.emit()
