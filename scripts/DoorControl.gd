extends CanvasLayer

# Moonbase/Interior/room_x
# Moonbase/PC_Interface/Desktop/DoorControl
@onready var sleeping_room = $"../../../Interior/SleepingRoom"
@onready var pod_room = $"../../../Interior/PodRoom"

@onready var sleeping_room_button: Button = $Window/Buttons/SleepingRoomDoor/Sleeping_Room_Button
@onready var sleeping_room_status: Label = $Window/Buttons/SleepingRoomDoor/Status
@onready var pod_room_button: Button = $Window/Buttons/PodRoomDoor/Pod_Room_Button
@onready var pod_room_status: Label = $Window/Buttons/PodRoomDoor/Status
@onready var pod_button: Button = $Window/Buttons/PodDoor/Pod_Door_Button
@onready var pod_status: Label = $Window/Buttons/PodDoor/Status

var control_sleeping_room_door
var control_pod_room_door
var control_pod_door

@export var icon_open: Texture
@export var icon_closed: Texture
var status_open_text = "STATUS_OPEN"
var status_open_color = Color.GREEN
var status_closed_text = "STATUS_CLOSED"
var status_closed_color = Color.RED
var status_inaccessible_text = "STATUS_INACCESSIBLE"
var status_inaccessible_color = Color.BLACK


func _ready():
	update_doors()
	
	control_sleeping_room_door = get_parent().get_parent().control_sleeping_room_door
	control_pod_room_door = get_parent().get_parent().control_pod_room_door
	control_pod_door = get_parent().get_parent().control_pod_door

func _process(delta):
	pass

func update_doors():
	var open = !sleeping_room.door_closed
	sleeping_room_button.icon = (icon_open if open else icon_closed)
	sleeping_room_status.text = status_inaccessible_text if !control_sleeping_room_door else (status_open_text if open else status_closed_text)
	sleeping_room_status.add_theme_color_override("font_color", status_inaccessible_color if !control_sleeping_room_door else (status_open_color if open else status_closed_color))
	
	open = !pod_room.door_closed
	pod_room_button.icon = (icon_open if open else icon_closed)
	pod_room_status.text = status_inaccessible_text if !control_pod_room_door else (status_open_text if open else status_closed_text)
	pod_room_status.add_theme_color_override("font_color", status_inaccessible_color if !control_pod_room_door else (status_open_color if open else status_closed_color))
	
	open = !pod_room.pod_door_closed
	pod_button.icon = (icon_open if open else icon_closed)
	pod_status.text = status_inaccessible_text if !control_pod_door else (status_open_text if open else status_closed_text)
	pod_status.add_theme_color_override("font_color", status_inaccessible_color if !control_pod_door else (status_open_color if open else status_closed_color))

func reset():
	pass


func _on_sleeping_room_button_pressed():
	if !control_sleeping_room_door:
		return
	var open = sleeping_room.door_closed
	sleeping_room.open_living_room_door(open, true)
	sleeping_room_button.icon = icon_open if open else icon_closed
	sleeping_room_status.text = status_open_text if open else status_closed_text
	sleeping_room_status.add_theme_color_override("font_color", status_open_color if open else status_closed_color)


func _on_pod_room_button_pressed():
	if !control_pod_room_door:
		return
	var open = pod_room.door_closed
	pod_room.open_living_room_door(open, true)
	pod_room_button.icon = icon_open if open else icon_closed
	pod_room_status.text = status_open_text if open else status_closed_text
	pod_room_status.add_theme_color_override("font_color", status_open_color if open else status_closed_color)


func _on_pod_door_button_pressed():
	if !control_pod_door:
		return
	var open = pod_room.pod_door_closed
	pod_room.open_pod_door(open, true)
	pod_button.icon = icon_open if open else icon_closed
	pod_status.text = status_open_text if open else status_closed_text
	pod_status.add_theme_color_override("font_color", status_open_color if open else status_closed_color)
