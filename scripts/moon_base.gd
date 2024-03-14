extends Node3D

@onready var interior = $"Interior"
@onready var living_room_wall_node = $"Interior/LivingRoom/LivingRoomWalls"
@onready var sleeping_room_wall_node = $"Interior/SleepingRoom/SleepingRoomWalls"
@onready var pod_room_wall_node = $"Interior/PodRoom/PodRoomWalls"
@onready var tube_and_wall_mesh_instance = $"Outer_Wall/Tube_and_Wall/MeshInstance3D"

@export var wall_mat: Material
@export var last_level: bool = false
@export var tesseract: RigidBody3D

var interiror_walls: Array[MeshInstance3D]

# Called when the node enters the scene tree for the first time.
func _ready():
	var all_walls = []
	for w in living_room_wall_node.get_children():
		all_walls.append(w.get_child(0))
	for w in sleeping_room_wall_node.get_children():
		all_walls.append(w.get_child(0))
	for w in pod_room_wall_node.get_children():
		all_walls.append(w.get_child(0))
		
	for c in all_walls:
		c.mesh.material = wall_mat
	# special treatment for tube wall
	tube_and_wall_mesh_instance.set_surface_override_material(1, wall_mat)
	
	$PC_Interface.visible = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_all_children(querry: Node) -> Array[Node]:
	var res: Array[Node] = []
	for c in querry.get_children():
		res.append(c)
		res.append_array(get_all_children(c))
	return res

# called by pod
func pod_escaped():
	get_parent().get_parent().pod_escaped()
