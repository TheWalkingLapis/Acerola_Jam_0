extends Node3D

@onready var area_up: Area3D = $"Areas/Up"
@onready var area_down: Area3D = $"Areas/Down"
@onready var area_right: Area3D = $"Areas/Right"
@onready var area_left: Area3D = $"Areas/Left"
@onready var area_reset: Area3D = $"Areas/Reset"

var open_func: Callable
var sound_func: Callable
var opened: bool
@export var password: String = "aaa" #not inputable
var current_attempt: String

func _ready():
	opened = false
	current_attempt = "_______"

func _process(delta):
	pass

func activate_area(area: Area3D):
	if opened:
		return
		
	if area == area_reset: # reset
		current_attempt = password
		for i in range(current_attempt.length()):
			current_attempt[i] = "_"
		sound_func.call()
	else: # insert value
		for i in range(current_attempt.length()):
			if current_attempt[i] == "_":
				var next_char = "_"
				match area:
					area_up:
						next_char = "u"
					area_down:
						next_char = "d"
					area_right:
						next_char = "r"
					area_left:
						next_char = "l"
				current_attempt[i] = next_char
				break
		if password == current_attempt:
			open_func.call(true)
			opened = true
	sound_func.call()

func attach_to_door(f: Callable):
	open_func = f
	
func audio_func(f: Callable):
	sound_func = f
