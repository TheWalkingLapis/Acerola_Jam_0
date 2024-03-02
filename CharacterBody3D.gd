extends CharacterBody3D

@export var movement_speed: float = 100.0
@export var sprint_multiplier: float = 2.5
@export var camera_sensitivity_x: float = 2.0
@export var camera_sensitivity_y: float = 1.0

@onready var cam: Camera3D = $Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	var movement_vec = Vector3(0,velocity.y,0)
	if Input.is_action_pressed("move_forward"):
		movement_vec += Vector3(0,0,-1)
	if Input.is_action_pressed("move_backward"):
		movement_vec += Vector3(0,0,1)
	if Input.is_action_pressed("move_right"):
		movement_vec += Vector3(1,0,0)
	if Input.is_action_pressed("move_left"):
		movement_vec += Vector3(-1,0,0)
	
	if movement_vec != Vector3(0,velocity.y,0):
		var movement: Vector3 = (transform.basis * movement_vec).normalized()
		movement *= movement_speed * delta
		if Input.is_action_pressed("sprint"):
			movement *= sprint_multiplier
		movement.y = velocity.y
		velocity = movement
	else:
		velocity = Vector3(0,velocity.y,0)
	
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y += 3
	else:
		velocity.y -= 8 * delta
	
	move_and_slide()
	
# handle camera movement
func _input(event):
	# if mouse is not captured don't change camera
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
		
	if event is InputEventMouseMotion:
		# make camera speed independent of viewport size by normaliting
		var mouse_movement = event.relative / get_viewport().get_visible_rect().size
		# rotate whole player aroung y-axis but only the camera around x-axis
		rotate(Vector3.UP, -mouse_movement.x * camera_sensitivity_x)
		cam.rotate(Vector3.RIGHT, -mouse_movement.y * camera_sensitivity_y)
		# prevent upside-down camera movement
		cam.rotation.x = clamp(cam.rotation.x, -0.45*PI, 0.45*PI)

