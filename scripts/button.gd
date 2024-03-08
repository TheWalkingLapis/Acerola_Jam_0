extends Node3D

var open_func: Callable

func _ready():
	pass

func _process(delta):
	pass

func activate_area(area: Area3D):
	open_func.call(true, true)

func attach_to_door(f: Callable):
	open_func = f
