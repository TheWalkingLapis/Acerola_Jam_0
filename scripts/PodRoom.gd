extends Node3D

@onready var door = $"Door"
@export var door_opening_speed: float = 2.5
var door_closed: bool = true
var door_offset: float = 0.0

@onready var pod_door_scanner = $Scanner
@onready var pod_door = $"Pod/Pod_Door"
@export var pod_door_rotation_speed: float = 0.8
var pod_door_closed: bool = true
var pod_door_rotation: float = 0.0

# Control/Environement/MoonBase/Interior/LivingRoom
# Control/Audio_Manager
@onready var audio_manager = $"../../../../Audio_Manager"

# Called when the node enters the scene tree for the first time.
func _ready():
	pod_door_scanner.attach_to_door(open_pod_door)
	pod_door_scanner.audio_func(audio_manager.play_button_press)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("TEST_open_close_doors"):
		open_living_room_door(true, true)
	if Input.is_action_just_pressed("TEST_open_close_pod"):
		open_pod_door(true, true)
	
	if door_offset != 0.0:
		door.translate(Vector3.UP * door_offset * delta)
		if door.position.y <= 2.5:
			door.position.y = 2.5
			door_offset = 0.0
		elif door.position.y >= 7.5:
			door.position.y = 7.5
			door_offset = 0.0
	
	if pod_door_rotation != 0.0:
		pod_door.rotate_y(pod_door_rotation * delta)
		
		if pod_door.get_rotation().y <= 0.0:
			pod_door.set_rotation(Vector3(0,0,0))
			pod_door_rotation = 0.0
		elif pod_door.get_rotation().y >= PI/2:
			pod_door.set_rotation(Vector3(0,PI/2,0))
			pod_door_rotation = 0.0

func open_living_room_door(opening: bool, swap_open_status: bool = false):
	if not swap_open_status:
		if not (door_closed == opening):
			return
	door_offset = 1.0 if door_closed else -1.0
	door_offset *= door_opening_speed
	door_closed = not door_closed

func open_pod_door(opening: bool, swap_open_status: bool = false):
		if not swap_open_status:
			if not (pod_door_closed == opening):
				return
		pod_door_rotation = 1.0 if pod_door_closed else -1.0
		pod_door_rotation *= pod_door_rotation_speed
		pod_door_closed = not pod_door_closed

#only detects player
func _on_entered_pod_body_entered(body):
	get_parent().get_parent().pod_reached()
