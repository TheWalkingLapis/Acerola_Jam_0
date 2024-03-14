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

# on pod launched
var pod_launched = false
var pod_warped = false

# Control/Environement/MoonBase/Interior/LivingRoom
# Control/Audio_Manager
@onready var audio_manager = $"../../../../Audio_Manager"

# Called when the node enters the scene tree for the first time.
func _ready():
	pod_door_scanner.attach_to_door(open_pod_door)
	pod_door_scanner.audio_func(audio_manager.play_button_press)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pod_launched:
		var player = get_parent().get_parent().get_parent().get_parent().get_node("Player")
		$Pod.position += delta * Vector3(0,3,0)
		if !pod_warped and $Pod.position.y > 7.0:
			pod_warped = true
			player.position.y += 15.0
			$Pod.position.y += 15.0
		if $Pod.position.y > 30.0:
			get_parent().get_parent().pod_escaped()
	
	if door_offset != 0.0:
		door.translate(Vector3.UP * door_offset * delta)
		if door.position.y <= 2.5:
			door.position.y = 2.5
			door_offset = 0.0
		elif door.position.y >= 7.5:
			door.position.y = 7.5
			door_offset = 0.0
	else:
		audio_manager.stop_pod_room_door_moving()
	
	if pod_door_rotation != 0.0:
		pod_door.rotate_y(pod_door_rotation * delta)
		
		if pod_door.get_rotation().y <= 0.0:
			pod_door.set_rotation(Vector3(0,0,0))
			pod_door_rotation = 0.0
		elif pod_door.get_rotation().y >= PI/2:
			pod_door.set_rotation(Vector3(0,PI/2,0))
			pod_door_rotation = 0.0
	else:
		audio_manager.stop_pod_door_moving()

func open_living_room_door(opening: bool, swap_open_status: bool = false):
	if not swap_open_status:
		if not (door_closed == opening):
			return
	door_offset = 1.0 if door_closed else -1.0
	door_offset *= door_opening_speed
	door_closed = not door_closed
	audio_manager.start_pod_room_door_moving()

func open_pod_door(opening: bool, swap_open_status: bool = false):
	if not swap_open_status:
		if not (pod_door_closed == opening):
			return
	pod_door_rotation = 1.0 if pod_door_closed else -1.0
	pod_door_rotation *= pod_door_rotation_speed
	pod_door_closed = not pod_door_closed

	audio_manager.start_pod_door_moving()

# called when player is contained in the pod
func launch_pod():
	if get_parent().get_parent().last_level:
		await audio_manager.stablizer_found_done
	else:
		await audio_manager.pod_entered_done
	# Control/Environment/MoonBase/Interior/PodRoom(/Pod/Area)
	# Control/Player
	var player = get_parent().get_parent().get_parent().get_parent().get_node("Player")
	player.start_cam_shake()
	pod_launched = true

#only detects player
func _on_entered_pod_body_entered(body):
	# Control/Environment/MoonBase/Interior/PodRoom(/Pod/Area)
	# Control/Player
	var player = get_parent().get_parent().get_parent().get_parent().get_node("Player")
	
	# MoonBase/Interior/PodRoom
	if get_parent().get_parent().last_level:
		if player.picked_up_item != get_parent().get_parent().tesseract:
			audio_manager.play_stabilizer_missing()
			return
		else:
			player.picked_up_item.queue_free()
			player.picked_up_item = null;
			audio_manager.play_stablizer_found()
	else:
		audio_manager.play_pod_entered()
	$Pod/Entered_Pod/CollisionShape3D.set_deferred("disabled", true)

	player.set_collision_layer_value(2, false)
	player.set_collision_layer_value(4, true)
	player.set_collision_mask_value(1, false)
	player.set_collision_mask_value(4, true)
	player.block_input = true
	open_pod_door(false, false)
	
	var tween_pos = get_tree().create_tween()
	tween_pos.tween_property(player, "global_position", $Pod/Pod_Chair.global_position + Vector3(0,2,0), 1.5 / pod_door_rotation_speed)
	tween_pos.tween_callback(player._unblock_input)
	tween_pos.tween_callback(launch_pod)
	var tween_rot = get_tree().create_tween()
	tween_rot.tween_property(player, "rotation", $Pod/Pod_Chair.rotation, 1.5 / pod_door_rotation_speed)
