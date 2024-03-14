extends CharacterBody3D

@export var movement_speed: float = 100.0
@export var camera_sensitivity_x: float = 2.0
@export var camera_sensitivity_y: float = 1.0

@onready var cam: Camera3D = $Camera3D

@export var pick_up_ray_length = 3.0
@export var interaction_ray_length = 2.5
var sneaking: bool = false
var picked_up_item: RigidBody3D = null
var has_keycard: bool = false
var last_mouse_movement: Vector2
var chaos_stage = 0.0
var block_input = false

func _ready():
	pass

var shake_strength = .5
var shake_now = 0.0
var old_cam_pos = Vector3.ZERO
var hud_hidden = false

func _process(delta):
	if shake_now > 0.0:
		$Camera3D.position = old_cam_pos + shake_now * Vector3(randf_range(-1, 1), randf_range(-1, 1), 0)
	
	if Input.is_action_just_pressed("Hide_HUD"):
		if !hud_hidden:
			$Camera3D/Crosshair.visible = false
			$Camera3D/Inventory_Slot.visible = false
		else:
			$Camera3D/Crosshair.visible = true
			$Camera3D/Inventory_Slot.visible = true
		hud_hidden = !hud_hidden
	
	if block_input:
		return

func start_cam_shake():
	shake_now = shake_strength
	old_cam_pos = $Camera3D.position

func _physics_process(delta):
	if block_input:
		return
	
	var movement_vec = Vector3(0,0,0)
	if Input.is_action_pressed("move_forward"):
		movement_vec += Vector3(0,0,-1)
	if Input.is_action_pressed("move_backward"):
		movement_vec += Vector3(0,0,1)
	if Input.is_action_pressed("move_right"):
		movement_vec += Vector3(1,0,0)
	if Input.is_action_pressed("move_left"):
		movement_vec += Vector3(-1,0,0)
	
	if movement_vec != Vector3(0,0,0):
		var movement: Vector3 = (transform.basis * movement_vec).normalized()
		movement *= movement_speed * delta
		movement.y = velocity.y
		velocity = movement
	else:
		velocity = Vector3(0,velocity.y,0)
	
	if is_on_floor():
		if not sneaking and Input.is_action_pressed("jump"):
			velocity.y += 5
	else:
		velocity.y -= 10 * delta
	move_and_slide()
	
	var cam_item_diff = Vector3(0,0,0)
	if picked_up_item != null:
		cam_item_diff = picked_up_item.global_position - cam.global_position
	if Input.is_action_just_pressed("sneak") and is_on_floor():
		scale *= 0.5
		movement_speed *= 0.5
		position -= Vector3(0,1.0,0)
		if picked_up_item != null:
			picked_up_item.global_position = cam.global_position + cam_item_diff
		sneaking = true
	if Input.is_action_just_released("sneak") and sneaking:
		scale *= 2.0
		movement_speed *= 2.0
		position += Vector3(0,1.0,0)
		if picked_up_item != null:
			picked_up_item.global_position = cam.global_position + cam_item_diff
		sneaking = false
	
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var space_state = get_world_3d().direct_space_state
	
	if picked_up_item == null:
		if Input.is_action_just_pressed("pick_up_item"):
			# Raycast and find item to pick up
			var from = cam.project_ray_origin(mouse_pos)
			var to = from + cam.project_ray_normal(mouse_pos) * pick_up_ray_length
			var query = PhysicsRayQueryParameters3D.create(from, to)
			var result = space_state.intersect_ray(query)
			if not result.is_empty():
				if result["collider"] is RigidBody3D:
					if result["collider"].freeze:
						return
					if result["collider"] == get_parent().get_keycard():
						get_parent().picked_up_keycard()
						has_keycard = true
						$"Camera3D/Inventory_Slot/Card_Icon".visible = true
						return
					picked_up_item = result["collider"]
					picked_up_item.gravity_scale = 0.0
					picked_up_item.set_collision_layer_value(1, false)
					picked_up_item.set_collision_layer_value(3, true)
					picked_up_item.set_collision_mask_value(2, false)
					picked_up_item.linear_velocity = Vector3.ZERO
					picked_up_item.angular_velocity = Vector3.ZERO
					picked_up_item.global_position = from + cam.project_ray_normal(mouse_pos) * 1.5
					print("Picked up " + str(picked_up_item))
	else: 
		if Input.is_action_just_pressed("pick_up_item"):
			picked_up_item.gravity_scale = 1.0
			picked_up_item.set_collision_layer_value(1, true)
			picked_up_item.set_collision_layer_value(3, false)
			picked_up_item.set_collision_mask_value(2, true)
			picked_up_item.apply_central_impulse(Vector3.DOWN * picked_up_item.mass * 0.1)
			print("Dropped " + str(picked_up_item))
			picked_up_item = null
		
	# move picked up item along
	if picked_up_item != null:
		var to_item: Vector3 = picked_up_item.global_position - cam.global_position
		var to_item_dir: Vector3 = to_item.normalized()
		var axis_x = to_item.cross(Vector3.UP).normalized()
		var axis_z = axis_x.cross(Vector3.DOWN).normalized()
		
		var to_new: Vector3 = to_item
		var angle_x = to_item_dir.signed_angle_to(axis_z, axis_x)
		if angle_x > 0.45*PI:
			to_new = axis_z.rotated(axis_x, -0.45*PI)
		elif angle_x < -0.45*PI:
			to_new = axis_z.rotated(axis_x, 0.45*PI)
		else:
			to_new = to_item.rotated(axis_x, -last_mouse_movement.y * camera_sensitivity_y)
		to_new = to_new.rotated(Vector3.UP, -last_mouse_movement.x * camera_sensitivity_x)
		# cam movement
		picked_up_item.position += -to_item + to_new
		# player movement
		picked_up_item.position += velocity * delta
		
		# rotation
		var rot_speed_horizontal: float = 4.0
		var rot_speed_vertical: float = 10.0
		if Input.is_action_pressed("rotate_item_left"):
			picked_up_item.rotate(Vector3.UP, -rot_speed_horizontal * delta)
		if Input.is_action_pressed("rotate_item_right"):
			picked_up_item.rotate(Vector3.UP, rot_speed_horizontal * delta)
		if Input.is_action_just_released("rotate_item_up"): # mouse wheel only has release action apparently
			picked_up_item.rotate(Vector3.RIGHT, rot_speed_vertical * delta)
		if Input.is_action_just_released("rotate_item_down"):
			picked_up_item.rotate(Vector3.RIGHT, -rot_speed_vertical * delta)
		
		if to_new.normalized().dot(cam.project_ray_normal(mouse_pos)) < .8:
			picked_up_item.gravity_scale = 1.0
			picked_up_item.set_collision_layer_value(1, true)
			picked_up_item.set_collision_layer_value(3, false)
			picked_up_item.set_collision_mask_value(2, true)
			picked_up_item.apply_central_impulse(Vector3.DOWN * picked_up_item.mass * 0.1)
			print("Dropped " + str(picked_up_item))
			picked_up_item = null
		
	last_mouse_movement = Vector2(0,0)
	
	if Input.is_action_just_pressed("interact") and picked_up_item == null:
		# Raycast to find object to interact
			var from = cam.project_ray_origin(mouse_pos)
			var to = from + cam.project_ray_normal(mouse_pos) * interaction_ray_length
			var query = PhysicsRayQueryParameters3D.create(from, to)
			query.set_collide_with_areas(true)
			var result = space_state.intersect_ray(query)
			if not result.is_empty():
				if result["collider"] is Area3D:
					var area: Area3D = result["collider"]
					if area.is_in_group("Scanner_Buttons"):
						var scanner = area.get_parent().get_parent()
						if scanner.has_method("activate_area"):
							var card_gone = scanner.activate_area(area, has_keycard)
							if card_gone:
								has_keycard = false
								$"Camera3D/Inventory_Slot/Card_Icon".visible = false
					if area.is_in_group("Buttons"):
						var button = area.get_parent()
						if button.has_method("activate_area"):
							button.activate_area(area)
					if area.is_in_group("Directional_Input_Buttons"):
						var scanner = area.get_parent().get_parent()
						if scanner.has_method("activate_area"):
							scanner.activate_area(area)
					if area.is_in_group("PC_Screen"):
						# MoonBase/Interior/LivingRoom/Desk/Screen/Area
						var living_room = area.get_parent().get_parent().get_parent()
						if living_room.has_method("enter_pc_interaction"):
							living_room.enter_pc_interaction()
							block_input = true
					if area.is_in_group("Speaker"):
						# MoonBase/Interior/LivingRoom/Desk/Speaker/Area
						var living_room = area.get_parent().get_parent().get_parent()
						if living_room.has_method("play_speaker"):
							living_room.play_speaker()
						
# handle camera movement
func _input(event):
	if block_input:
		return
	# if mouse is not captured don't change camera
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
		
	if event is InputEventMouseMotion:
		# make camera speed independent of viewport size by normaliting
		last_mouse_movement = event.relative / get_viewport().get_visible_rect().size
		# rotate whole player aroung y-axis but only the camera around x-axis
		rotate(Vector3.UP, -last_mouse_movement.x * camera_sensitivity_x)
		cam.rotate(Vector3.RIGHT, -last_mouse_movement.y * camera_sensitivity_y)
		# prevent upside-down camera movement
		cam.rotation.x = clamp(cam.rotation.x, -0.45*PI, 0.45*PI)

func _unblock_input():
	block_input = false
