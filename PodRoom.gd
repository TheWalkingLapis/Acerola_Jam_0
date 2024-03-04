extends Node3D

@onready var pod_door = $"Pod/Pod_Door"
@export var pod_door_rotation_speed: float = 0.8
var pod_door_closed: bool = true
var pod_door_rotation: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("TEST_open_close_pod"):
		pod_door_rotation = 1.0 if pod_door_closed else -1.0
		pod_door_rotation *= pod_door_rotation_speed
		pod_door_closed = not pod_door_closed
	
	if pod_door_rotation != 0.0:
		pod_door.rotate_y(pod_door_rotation * delta)
		
		if pod_door.get_rotation().y <= 0.0:
			pod_door.set_rotation(Vector3(0,0,0))
			pod_door_rotation = 0.0
		elif pod_door.get_rotation().y >= PI/2:
			pod_door.set_rotation(Vector3(0,PI/2,0))
			pod_door_rotation = 0.0
