extends Node3D

@onready var door = $"Door"
@onready var door_button = $"Living_Room_Button"
@export var door_opening_speed: float = 2.5
var door_closed: bool = true
var door_offset: float = 0.0

@onready var safe_door = $"Safe/Door"
@onready var safe_door_input = $"Safe/Door/Directional_Input"
@export var safe_door_opening_speed: float = 2.5
var safe_door_closed: bool = true
var safe_door_rotation: float = 0.0

# Control/Environement/MoonBase/Interior/LivingRoom
# Control/Audio_Manager
@onready var audio_manager = $"../../../../Audio_Manager"

func _ready():
	door_button.attach_to_door(open_living_room_door)
	safe_door_input.attach_to_door(open_safe_door)
	safe_door_input.audio_func(audio_manager.play_button_press)

func _process(delta):
	if Input.is_action_just_pressed("TEST_open_close_doors"):
		open_living_room_door(true, true)
	if Input.is_action_just_pressed("TEST_open_close_pod"):
		open_safe_door(true, true)
	
	if door_offset != 0.0:
		door.translate(Vector3.UP * door_offset * delta)
		if door.position.y <= 2.5:
			door.position.y = 2.5
			door_offset = 0.0
		elif door.position.y >= 7.5:
			door.position.y = 7.5
			door_offset = 0.0
			
	if safe_door_rotation != 0.0:
		safe_door.rotate_y(safe_door_rotation * delta)
		
		if safe_door.get_rotation().y >= 0.0:
			safe_door.set_rotation(Vector3(0,0,0))
			safe_door_rotation = 0.0
		elif safe_door.get_rotation().y <= -PI/2:
			safe_door.set_rotation(Vector3(0,-PI/2,0))
			safe_door_rotation = 0.0

func open_living_room_door(opening: bool, swap_open_status: bool = false):
	if not swap_open_status:
		if not (door_closed == opening):
			return
	door_offset = 1.0 if door_closed else -1.0
	door_offset *= door_opening_speed
	door_closed = not door_closed

func open_safe_door(opening: bool, swap_open_status: bool = false):
	if not swap_open_status:
		if not (safe_door_closed == opening):
			return
	safe_door_rotation = -1.0 if safe_door_closed else 1.0
	safe_door_rotation *= safe_door_opening_speed
	safe_door_closed = not safe_door_closed
