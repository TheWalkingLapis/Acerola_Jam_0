extends Node3D

@onready var door = $"Door"
@export var door_opening_speed: float = 2.5
var door_closed: bool = true
var door_offset: float = 0.0

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("TEST_open_close_doors"):
		door_offset = 1.0 if door_closed else -1.0
		door_offset *= door_opening_speed
		door_closed = not door_closed
	
	if door_offset != 0.0:
		door.translate(Vector3.UP * door_offset * delta)
		if door.position.y <= 2.5:
			door.position.y = 2.5
			door_offset = 0.0
		elif door.position.y >= 7.5:
			door.position.y = 7.5
			door_offset = 0.0
