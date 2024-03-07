extends Node3D

@onready var pod_room_scanner: Node3D = $"Scanner_pod_room"
@onready var pod_room: Node3D = $"../PodRoom"

# Called when the node enters the scene tree for the first time.
func _ready():
	pod_room_scanner.attach_to_door(pod_room.open_living_room_door)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
