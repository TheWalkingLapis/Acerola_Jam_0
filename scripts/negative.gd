extends ColorRect

var start = false
var time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !start:
		return
	
	time += delta
	if time >= 2.0:
		material.set_shader_parameter("time", time - 2.0)

func start_restart():
	start = true
	get_parent().get_node("Crosshair").visible = false
	get_parent().get_node("Inventory_Slot").visible = false
	visible = true
	material.set_shader_parameter("time", 0.0)
