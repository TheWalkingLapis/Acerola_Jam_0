extends RigidBody3D

var rot_axis = Vector3.UP
var axis_change = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rot_axis.x += axis_change * randf_range(-1., 1.)
	rot_axis.y += axis_change * randf_range(-1., 1.)
	rot_axis.z += axis_change * randf_range(-1., 1.)
	rot_axis = rot_axis.normalized()
	$CollisionShape3D/Inner.rotate(rot_axis, 10 * delta * randf_range(.8, 1.2))
